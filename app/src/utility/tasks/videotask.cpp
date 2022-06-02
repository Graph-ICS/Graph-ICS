#include "videotask.h"

#include "cutframescommand.h"
#include "fileio.h"
#include "pasteframescommand.h"

#include <QFile>

namespace G
{

VideoTask::VideoTask()
    : ImageTask()
    , m_inputNode(nullptr)
    , m_savePoints({0}) // default savepoint 0
    , m_videoNode(nullptr)
    , m_frameId(0)
    , m_requestedFrameId(m_frameId)
    , m_processFrameId(m_frameId)
    , m_previousState(-1)
    , m_editFromFrameId(0)
    , m_editToFrameId(0)
    , m_pastePosition(0)
    , m_frameMap()
    , m_commandHistory()
    , m_copyFramesCommand(m_frameMap)
    , m_saveVideoRequested(false)
    , m_cancelSaveVideoRequested(false)
    , m_saveVideoStarted(false)
    , m_savePath("")
#ifdef _WIN32
    , m_supportedVideoFiles({".mp4", ".avi"})
    , m_videoCodecs({{".mp4", "mp4v"}, {".avi", "mp4v"}})
#elif __APPLE__
    , m_supportedVideoFiles({".mp4", ".avi"})
    , m_videoCodecs({{".mp4", "avc1"}, {".avi", "MJPG"}})
#elif __linux__
    , m_supportedVideoFiles({".avi"})
    , m_videoCodecs({{".avi", "MJPG"}})
#endif
    , m_videoWriter()
    , m_firstRun(true)
    , m_ignoreFps(false)
{
}

void VideoTask::init(Node* node)
{
    Q_ASSERT(node->getType() == Node::OUTPUT);

    m_node = node;
    m_inputNode = node->getInputNode();
    m_videoNode = qobject_cast<Video*>(m_inputNode);

    Q_ASSERT(m_videoNode != nullptr);

    m_videoNode->openVideo();
    int amount = m_videoNode->getAmountOfFrames();

    for (int i = m_frameMap.size(); i < amount; i++)
    {
        m_frameMap.push_back(i);
    }
    emit amountOfFramesChanged();
}

bool VideoTask::isCancelAllowed()
{
    QMutexLocker locker(getScheduler()->getMutex());
    int undoDepth = m_commandHistory.getUndoDepth();
    for (auto& sp : m_savePoints)
    {
        if (undoDepth - sp == 0)
        {
            return true;
        }
    }
    m_cancelNotAllowedReason = UNSAVED_VIDEO;
    return false;
}

bool VideoTask::isStopAllowed() const
{
    QMutexLocker locker(getScheduler()->getMutex());
    return !isStateChangeRequested() && getState() != STOP && !m_saveVideoRequested;
}

bool VideoTask::isPlayAllowed() const
{
    QMutexLocker locker(getScheduler()->getMutex());
    return !isStateChangeRequested() && getState() != PLAY && !m_saveVideoRequested;
}

bool VideoTask::isPauseAllowed() const
{
    QMutexLocker locker(getScheduler()->getMutex());
    return !isStateChangeRequested() && getState() == PLAY && !m_saveVideoRequested;
}

bool VideoTask::isSaveVideoAllowed() const
{
    QMutexLocker locker(getScheduler()->getMutex());
    return !m_saveVideoRequested && !m_cancelSaveVideoRequested && getAmountOfFrames() > 0;
}

bool VideoTask::isCancelSaveVideoAllowed() const
{
    QMutexLocker locker(getScheduler()->getMutex());
    return m_saveVideoRequested && !m_cancelSaveVideoRequested;
}

bool VideoTask::isSavingVideo() const
{
    return m_saveVideoStarted;
}

bool VideoTask::isCutFramesAllowed() const
{
    if (isSavingVideo())
    {
        return false;
    }
    if (m_editFromFrameId > m_editToFrameId)
    {
        return false;
    }
    if (m_editFromFrameId < 0 || m_editToFrameId < 0)
    {
        return false;
    }
    int amountOfFrames = getAmountOfFrames();
    if (m_editFromFrameId >= amountOfFrames || m_editToFrameId >= amountOfFrames)
    {
        return false;
    }
    if (m_editFromFrameId + m_editToFrameId == amountOfFrames - 1)
    {
        return false;
    }
    return true;
}

bool VideoTask::isCopyFramesAllowed() const
{
    return !isSavingVideo();
}

bool VideoTask::isPasteFramesAllowed() const
{
    if (m_pastePosition < 0 || m_pastePosition >= getAmountOfFrames() || isSavingVideo())
    {
        return false;
    }
    return m_copyFramesCommand.hasCopy();
}

bool VideoTask::isUndoAllowed() const
{
    return !isSavingVideo() && m_commandHistory.canUndo();
}

bool VideoTask::isRedoAllowed() const
{
    return !isSavingVideo() && m_commandHistory.canRedo();
}

void VideoTask::stop()
{
    QMutexLocker locker(getScheduler()->getMutex());
    switch (getState())
    {
        case PLAY:
        case PAUSE:
            changeState(STOP);
            suspend();
            updateFrameId(0);
            break;
        default:
            break;
    }
}

void VideoTask::play()
{
    QMutexLocker locker(getScheduler()->getMutex());
    switch (getState())
    {
        case STOP:
        case PAUSE:
            changeState(PLAY);
            resume();
            break;
        default:
            break;
    }
}

void VideoTask::pause()
{
    QMutexLocker locker(getScheduler()->getMutex());
    switch (getState())
    {
        case PLAY:
            changeState(PAUSE);
            suspend();
            break;
        default:
            break;
    }
}

QList<QString> VideoTask::getSupportedVideoFiles() const
{
    return m_supportedVideoFiles;
}

void VideoTask::saveVideoAs(QString filepath)
{
    QMutexLocker locker(getScheduler()->getMutex());

    filepath = FileIO::removePathoverhead(filepath);

    if (!setSupportedFiletype(filepath, m_supportedVideoFiles))
    {
        stop();
        emit saveResultAsFinished(FILE_NOT_SUPPORTED);
        return;
    }

    m_savePath = filepath;
    updateFrameId(0);
    setIgnoreFps(true);
    m_firstRun = true;
    m_cancelSaveVideoRequested = false;
    m_saveVideoRequested = true;

    emit allowedChanged();

    play();
}

void VideoTask::cancelSaveVideo()
{
    QMutexLocker locker(getScheduler()->getMutex());
    m_cancelSaveVideoRequested = true;
    m_saveVideoRequested = false;

    emit allowedChanged();
}

void VideoTask::cutFrames()
{
    QMutexLocker locker(getScheduler()->getMutex());
    m_copyFramesCommand.setFromTo(m_editFromFrameId, m_editToFrameId);
    m_copyFramesCommand.execute();

    Command::Pointer cutCommand(new CutFramesCommand(m_frameMap, m_editFromFrameId, m_editToFrameId));
    cutCommand->execute();
    m_commandHistory.add(cutCommand);

    fixFrameIdAfterEditing();
    fixSavePointsAfterEditing();

    emit editPropertyChanged();
}

void VideoTask::copyFrames()
{
    QMutexLocker locker(getScheduler()->getMutex());
    m_copyFramesCommand.setFromTo(m_editFromFrameId, m_editToFrameId);
    m_copyFramesCommand.execute();
    emit editPropertyChanged();
}

void VideoTask::pasteFrames()
{
    QMutexLocker locker(getScheduler()->getMutex());
    Command::Pointer pasteCommand(new PasteFramesCommand(m_frameMap, m_copyFramesCommand, m_pastePosition));
    pasteCommand->execute();
    m_commandHistory.add(pasteCommand);

    fixFrameIdAfterEditing();
    fixSavePointsAfterEditing();

    emit editPropertyChanged();
}

void VideoTask::undoCommand()
{
    QMutexLocker locker(getScheduler()->getMutex());
    m_commandHistory.undo();
    fixFrameIdAfterEditing();
    emit editPropertyChanged();
}

void VideoTask::redoCommand()
{
    QMutexLocker locker(getScheduler()->getMutex());
    m_commandHistory.redo();
    fixFrameIdAfterEditing();
    emit editPropertyChanged();
}

void VideoTask::startSliding(const int& frameId)
{
    QMutexLocker locker(getScheduler()->getMutex());
    if (m_saveVideoRequested)
    {
        qDebug() << "VideoTask::startSliding: Sliding is not allowed when saving a video!";
        return;
    }
    setInterval(-1);
    m_previousState = getState();
    play();
    getScheduler()->wakeUp();
    setFrameId(frameId);
}

void VideoTask::endSliding(const int& frameId)
{
    QMutexLocker locker(getScheduler()->getMutex());
    if (m_saveVideoRequested)
    {
        qDebug() << "VideoTask::endSliding: Sliding is not allowed when saving a video!";
        return;
    }
    if (m_previousState != PLAY)
    {
        pause();
    }
    m_previousState = -1;
    updateFrameId(frameId);
}

int VideoTask::getEditFromFrameId() const
{
    return m_editFromFrameId;
}

void VideoTask::setEditFromFrameId(const int& fromFrameId)
{
    if (m_editFromFrameId != fromFrameId)
    {
        m_editFromFrameId = fromFrameId;
        emit editPropertyChanged();
    }
}

int VideoTask::getEditToFrameId() const
{
    return m_editToFrameId;
}

void VideoTask::setEditToFrameId(const int& toFrameId)
{
    if (m_editToFrameId != toFrameId)
    {
        m_editToFrameId = toFrameId;
        emit editPropertyChanged();
    }
}

int VideoTask::getPastePosition() const
{
    return m_pastePosition;
}

void VideoTask::setPastePosition(const int& pp)
{
    if (m_pastePosition != pp)
    {
        m_pastePosition = pp;
        emit editPropertyChanged();
    }
}

int VideoTask::getAmountOfCopiedFrames() const
{
    return m_copyFramesCommand.getCopiedFrames().size();
}

int VideoTask::getFrameId() const
{
    return m_frameId;
}

void VideoTask::setFrameId(const int& frameId)
{
    QMutexLocker locker(getScheduler()->getMutex());
    if (m_saveVideoRequested)
    {
        qDebug() << "VideoTask::setTaskFrameId: Cannot change frameId while saving video!";
        return;
    }
    m_requestedFrameId = frameId;
}

int VideoTask::getAmountOfFrames() const
{
    return m_frameMap.size();
}

void VideoTask::setIgnoreFps(const bool& value)
{
    QMutexLocker locker(getScheduler()->getMutex());
    m_ignoreFps = value;
}

void VideoTask::execute()
{
    if (getState() == PAUSE)
    {
        return;
    }

    setOffset();

    QMutexLocker locker(getScheduler()->getMutex());

    if (isSuspendRequested() || isCancelRequested())
    {
        return;
    }
    // m_previousState is only set if the user wants to slide the frameSlider
    bool isSliding = m_previousState != -1;

    if (m_frameId != m_requestedFrameId)
    {
        updateFrameId(m_requestedFrameId);
    }
    else
    {
        if (isSliding)
        {
            // do not process the same frame more than once when sliding
            return;
        }
        else
        {
            if (getAmountOfFrames() > 0 && !m_firstRun)
            {
                updateFrameId((m_frameId + 1) % getAmountOfFrames());
            }
            else
            {
                updateFrameId(0);
            }
        }
    }

    if (m_saveVideoRequested && !m_saveVideoStarted)
    {
        updateFrameId(0);
        m_saveVideoStarted = true;
        emit savingVideoChanged();
        emit editPropertyChanged();
    }

    // the actual frameId to process
    m_processFrameId = getMappedFrameId(m_frameId);

    locker.unlock();
    if (!startProcess(m_node))
    {
        if (m_saveVideoRequested)
        {
            cleanupAfterSaveVideo(EMPTY_RESULT);
        }
        cancel();
        return;
    }
    locker.relock();

    if (m_cancelSaveVideoRequested)
    {
        cleanupAfterSaveVideo(CANCELLED);
        pause();
    }

    if (m_saveVideoStarted)
    {
        if (!m_videoWriter.isOpened())
        {
            if (!openVideoWriter())
            {
                qDebug() << "Failed to open VideoWriter!";
                cleanupAfterSaveVideo(WRITER_ERROR);
                stop();
                return;
            }
        }
        m_videoWriter.write(m_node->getInPort(0)->getGImage()->getCvMatImage());
    }

    if (isSliding || m_ignoreFps)
    {
        setInterval(-1);
    }
    else
    {
        handleFps(m_inputNode);
    }

    if (m_frameId == getAmountOfFrames() - 1 && !isSliding)
    {
        stop();
        if (m_saveVideoStarted)
        {
            // saved video successfully
            cleanupAfterSaveVideo(SUCCESSED);
        }
    }

    m_firstRun = false;
}

void VideoTask::setAmountOfFrames(const int& amount)
{
    QMutexLocker locker(getScheduler()->getMutex());
    if (m_frameMap.size() != amount)
    {
        for (int i = m_frameMap.size(); i < amount; i++)
        {
            m_frameMap.push_back(i);
        }
        emit amountOfFramesChanged();
    }
}

void VideoTask::updateFrameId(const int& frameId)
{
    QMutexLocker locker(getScheduler()->getMutex());
    if (m_frameId != frameId)
    {
        m_frameId = frameId;
        m_requestedFrameId = m_frameId;
        emit frameIdChanged();
    }
}

void VideoTask::clearFrameMap()
{
    QMutexLocker locker(getScheduler()->getMutex());
    m_frameMap.clear();
    emit amountOfFramesChanged();
}

int VideoTask::getMappedFrameId(const int& frameId)
{
    QMutexLocker locker(getScheduler()->getMutex());
    int mappedId = frameId;
    if (m_frameMap.size() > 0)
    {
        mappedId = mappedId % m_frameMap.size();
        if (mappedId < m_frameMap.size())
        {
            mappedId = m_frameMap.at(mappedId);
        }
        else
        {
            qDebug() << "mappedId >= m_frameMap.size()" << mappedId;
        }
    }
    return mappedId;
}

void VideoTask::handleFps(Node* inputNode)
{
    double fps = inputNode->getAttribute("fps")->getValue().toDouble();

    if (fps == 0.0f)
    {
        setInterval(-1);
        pause();
    }
    else
    {
        setInterval(1000 / fps);
    }
}

bool VideoTask::process(Node* node, Port* fromPort, Port* toPort)
{
    if (isSuspendRequested() || isCancelRequested())
    {
        return true;
    }

    if (fromPort->hasCache(m_processFrameId))
    {
        fromPort->retrieveCache(m_processFrameId);
    }
    else
    {
        if (m_videoNode->getFrameId() != m_processFrameId)
        {
            m_videoNode->setFrameId(m_processFrameId);
        }

        if (!startProcess(node))
        {
            return false;
        }

        if (getAmountOfFrames() == 0)
        {
            setAmountOfFrames(m_videoNode->getAmountOfFrames());
        }

        fromPort->cacheResult(m_processFrameId);
    }

    forwardResult(fromPort, toPort);
    return true;
}

bool VideoTask::openVideoWriter()
{
    double videoFps = m_inputNode->getAttribute("fps")->getValue().toDouble();

    cv::Mat& sample = m_node->getInPort(0)->getGImage()->getCvMatImage();
    // only image writing supported for now
    // can only be empty if we are working with GData
    Q_ASSERT(!sample.empty());

    cv::Size size = sample.size();
    bool color = false;
    if (sample.type() == CV_8UC3)
    {
        color = true;
    }

    QString fourCCString = m_videoCodecs.value(m_filetype);

    if (fourCCString.isEmpty())
    {
        return false;
    }

    int codec = cv::VideoWriter::fourcc(fourCCString.at(0).toLatin1(), fourCCString.at(1).toLatin1(),
                                        fourCCString.at(2).toLatin1(), fourCCString.at(3).toLatin1());

    return m_videoWriter.open(m_savePath.toStdString(), codec, videoFps, size, color);
}

void VideoTask::cleanupAfterSaveVideo(SAVE_STATUS status)
{
    QMutexLocker locker(getScheduler()->getMutex());

    if (m_videoWriter.isOpened())
    {
        m_videoWriter.release();
    }

    if (status == SUCCESSED)
    {
        int undoDepth = m_commandHistory.getUndoDepth();
        if (!m_savePoints.contains(undoDepth))
        {
            m_savePoints.append(undoDepth);
        }
        emit saveResultAsFinished(status);
    }
    else
    {
        QFile file(m_savePath);
        if (file.exists())
        {
            if (!file.remove(m_savePath))
            {
                qDebug() << "VideoTask::saveFailed: could not remove the corrupted file!";
            }
        }
        emit saveResultAsFinished(status);
    }

    m_savePath = "";
    m_saveVideoRequested = false;
    m_cancelSaveVideoRequested = false;
    m_saveVideoStarted = false;
    setIgnoreFps(false);
    updateFrameId(0);

    emit allowedChanged();
    emit editPropertyChanged();
    emit savingVideoChanged();
}

void VideoTask::fixFrameIdAfterEditing()
{
    int lastFrameId = getAmountOfFrames() - 1;
    if (m_frameId > lastFrameId)
    {
        updateFrameId(lastFrameId);
    }
    if (m_pastePosition > lastFrameId)
    {
        m_pastePosition = lastFrameId;
    }
    m_editFromFrameId = 0;
    m_editToFrameId = 0;
    emit amountOfFramesChanged();
    emit editPropertyChanged();
}

void VideoTask::fixSavePointsAfterEditing()
{
    int undoDepth = m_commandHistory.getUndoDepth();
    for (int i = 0; i < m_savePoints.length(); i++)
    {
        if (m_savePoints[i] >= undoDepth)
        {
            m_savePoints.remove(i);
            i--;
        }
    }
}

} // namespace G
