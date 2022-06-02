#include "imagetask.h"

#include "fileio.h"

#include "model/input/image.h"

#include <QImageWriter>
#include <QThread>

namespace G
{

ImageTask::ImageTask()
    : Task()
    , m_node(nullptr)
    , m_filetype("")
    , m_supportedImageFiles({".jpg", ".png"})
    , m_nodeLocked(false)
    , m_state(STOP)
    , m_requestedState(STOP)
{
}

void ImageTask::init(Node* node)
{
    Q_ASSERT(node->getType() == Node::OUTPUT);
    m_node = node;
}

bool ImageTask::isStopAllowed() const
{
    QMutexLocker locker(getScheduler()->getMutex());
    return !isStateChangeRequested() && getState() == PLAY;
}

bool ImageTask::isPlayAllowed() const
{
    QMutexLocker locker(getScheduler()->getMutex());
    return !isStateChangeRequested() && getState() == STOP;
}

void ImageTask::stop()
{
    QMutexLocker locker(getScheduler()->getMutex());
    switch (getState())
    {
        case PLAY:
            changeState(STOP);
            suspend();
            break;
        default:
            break;
    }
}

void ImageTask::play()
{
    QMutexLocker locker(getScheduler()->getMutex());
    switch (getState())
    {
        case STOP:
            changeState(PLAY);
            resume();
            break;
        default:
            break;
    }
}

QList<QString> ImageTask::getSupportedImageFiles() const
{
    return m_supportedImageFiles;
}

void ImageTask::saveImageAs(QString filepath)
{
    QMutexLocker locker(getScheduler()->getMutex());

    filepath = FileIO::removePathoverhead(filepath);

    if (!setSupportedFiletype(filepath, m_supportedImageFiles))
    {
        emit saveResultAsFinished(FILE_NOT_SUPPORTED);
        return;
    }

    Port* inPort = m_node->getInPort(0);
    QImage& image = inPort->getGImage()->getQImage();

    if (image.isNull())
    {
        emit saveResultAsFinished(EMPTY_RESULT);
        return;
    }

    QImageWriter writer(filepath);
    writer.setOptimizedWrite(true);

    if (!writer.write(image))
    {
        qDebug() << writer.errorString();
        emit saveResultAsFinished(WRITER_ERROR);
        return;
    }

    emit saveResultAsFinished(SUCCESSED);
}

int ImageTask::getState() const
{
    return m_state;
}

void ImageTask::changeState(int state)
{
    QMutexLocker locker(getScheduler()->getMutex());
    m_requestedState = state;
    getScheduler()->wakeUp();

    emit allowedChanged();
}

bool ImageTask::isStateChangeRequested() const
{
    QMutexLocker locker(getScheduler()->getMutex());
    return m_requestedState != m_state;
}

void ImageTask::update()
{
    QMutexLocker locker(getScheduler()->getMutex());
    Task::update();
    if (m_state != m_requestedState)
    {
        m_state = m_requestedState;
        emit stateChanged();

        emit allowedChanged();
    }
}

void ImageTask::execute()
{
    if (getState() == PLAY)
    {
        if (!startProcess(m_node))
        {
            cancel();
            return;
        }
        stop();
    }
}

bool ImageTask::startProcess(Node* node)
{
    if (!processInNodes(node))
    {
        return false;
    }

    if (!node->retrieveResult())
    {
        node->setStatus(Node::STATUS::RETRIEVE_RESULT_FAILED);
        return false;
    }

    return true;
}

bool ImageTask::processInNodes(Node* node)
{
    if (node->isInPortConnectionMissing())
    {
        node->setStatus(Node::STATUS::IN_PORT_CONNECTION_MISSING);
        return false;
    }

    for (int i = 0; i < node->getInPortsCount(); i++)
    {
        Port* inPort = node->getInPort(i);
        if (inPort->hasConnectedPort())
        {
            bool keepQueryGoing = process(node->getInNode(i), inPort->getConnectedPort(), inPort);
            if (!keepQueryGoing)
            {
                return false;
            }
        }
    }
    return true;
}

bool ImageTask::process(Node* node, Port* fromPort, Port* toPort)
{
    if (isSuspendRequested() || isCancelRequested())
    {
        return true;
    }

    if (fromPort->hasCache(0))
    {
        fromPort->retrieveCache(0);
    }
    else
    {
        if (!startProcess(node))
        {
            return false;
        }

        fromPort->cacheResult(0);
    }

    forwardResult(fromPort, toPort);
    return true;
}

void ImageTask::forwardResult(Port* outPort, Port* inPort)
{
    Port::TYPE outType = outPort->getType();

    if (outType == Port::TYPE::GIMAGE)
    {
        inPort->setGImage(outPort->getGImage());
    }
    if (outType == Port::TYPE::GDATA)
    {
        inPort->setGData(outPort->getGData());
    }
}

void ImageTask::onResumed()
{
    if (!m_nodeLocked)
    {
        m_nodeLocked = true;
        m_node->lock();
    }
}

void ImageTask::onSuspended()
{
    if (m_nodeLocked)
    {
        m_nodeLocked = false;
        m_node->unlock();
    }
}

void ImageTask::onCancelled()
{
    onSuspended();
    m_node->clearCache();
}

bool ImageTask::setSupportedFiletype(QString filepath, QList<QString> supportedFiles)
{
    for (auto& type : supportedFiles)
    {
        if (filepath.endsWith(type))
        {
            m_filetype = type;
            return true;
        }
    }
    return false;
}

} // namespace G
