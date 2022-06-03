#include "cameratask.h"

namespace G
{

CameraTask::CameraTask()
    : VideoTask()
    , m_cameraNode(nullptr)
    , m_openCameraRequested(false)
    , m_closeCameraRequested(false)
    , m_finalizeRecording(false)
    , m_hasRecordedFrames(false)
    , m_camOn(false)
{
}

CameraTask::~CameraTask()
{
}

void CameraTask::init(Node* node)
{
    Q_ASSERT(node->getType() == Node::OUTPUT);
    m_node = node;
    m_inputNode = node->getInputNode();

    m_cameraNode = qobject_cast<Camera*>(m_inputNode);

    Q_ASSERT(m_cameraNode != nullptr);
}

bool CameraTask::isCancelAllowed()
{
    QMutexLocker locker(getScheduler()->getMutex());
    if (VideoTask::isCancelAllowed())
    {
        if (getState() == RECORD || getState() == RECORD_PAUSE)
        {
            m_cancelNotAllowedReason = IS_RECORDING_VIDEO;
            return false;
        }

        return true;
    }
    m_cancelNotAllowedReason = UNSAVED_VIDEO;
    return false;
}

bool CameraTask::isStopAllowed() const
{
    QMutexLocker locker(getScheduler()->getMutex());
    return !isStateChangeRequested() && !m_openCameraRequested && getState() != STOP;
}

bool CameraTask::isPlayAllowed() const
{
    QMutexLocker locker(getScheduler()->getMutex());
    int state = getState();
    return !isStateChangeRequested() && !m_openCameraRequested && m_hasRecordedFrames &&
           (state == STOP || state == PAUSE);
}

bool CameraTask::isPauseAllowed() const
{
    QMutexLocker locker(getScheduler()->getMutex());
    int state = getState();
    return !isStateChangeRequested() && !m_openCameraRequested && (state == PLAY || state == RECORD);
}

bool CameraTask::isRecordAllowed() const
{
    QMutexLocker locker(getScheduler()->getMutex());
    int state = getState();
    return !isStateChangeRequested() && !m_openCameraRequested && state != RECORD;
}

bool CameraTask::isOpenCameraAllowed() const
{
    QMutexLocker locker(getScheduler()->getMutex());
    return !isStateChangeRequested() && !m_camOn && !m_openCameraRequested && !m_closeCameraRequested;
}

bool CameraTask::isCloseCameraAllowed() const
{
    QMutexLocker locker(getScheduler()->getMutex());
    return !isStateChangeRequested() && m_camOn && !m_openCameraRequested && !m_closeCameraRequested;
}

bool CameraTask::isCamOn() const
{
    QMutexLocker locker(getScheduler()->getMutex());
    return m_camOn;
}

bool CameraTask::isCameraDeviceOpen() const
{
    QMutexLocker locker(getScheduler()->getMutex());
    return m_cameraNode->isCameraDeviceOpen();
}

bool CameraTask::isSaveVideoAllowed() const
{
    QMutexLocker locker(getScheduler()->getMutex());
    return m_hasRecordedFrames && VideoTask::isSaveVideoAllowed();
}

void CameraTask::stop()
{
    QMutexLocker locker(getScheduler()->getMutex());
    switch (getState())
    {
        case PLAY:
        case PAUSE:
            updateFrameId(0);
            suspend();
            changeState(STOP);
            break;
        case RECORD:
        case RECORD_PAUSE:
            m_finalizeRecording = true;
            resume();
            changeState(STOP);
            break;
        default:
            break;
    }
}

void CameraTask::play()
{
    QMutexLocker locker(getScheduler()->getMutex());
    switch (getState())
    {
        case STOP:
        case PAUSE:
            closeCamera();
            resume();
            changeState(PLAY);
            break;
        default:
            break;
    }
}

void CameraTask::pause()
{
    QMutexLocker locker(getScheduler()->getMutex());
    switch (getState())
    {
        case PLAY:
            suspend();
            changeState(PAUSE);
            break;
        case RECORD:
            changeState(RECORD_PAUSE);
            break;
        default:
            break;
    }
}

void CameraTask::record()
{
    QMutexLocker locker(getScheduler()->getMutex());
    switch (getState())
    {
        case PLAY:
        case PAUSE:
            updateFrameId(0);
        case STOP:
        case RECORD_PAUSE:
            if (!m_camOn && !m_openCameraRequested)
            {
                openCamera();
            }
            changeState(RECORD);
            resume();
            break;
        default:
            break;
    }
}

void CameraTask::clearRecordedFrames()
{
    QMutexLocker locker(getScheduler()->getMutex());
    clearFrameMap();
    updateFrameId(0);

    if (m_hasRecordedFrames)
    {
        // free up additional lock to enable attribute changes
        m_node->unlock();
        m_hasRecordedFrames = false;
    }

    emit allowedChanged();
}

void CameraTask::openCamera()
{
    QMutexLocker locker(getScheduler()->getMutex());
    if (!m_camOn)
    {
        m_openCameraRequested = true;

        int currentState = getState();
        if (currentState == PLAY || currentState == PAUSE)
        {
            updateFrameId(0);
            changeState(STOP);
        }
        resume();
        emit allowedChanged();
    }
}

void CameraTask::closeCamera()
{
    QMutexLocker locker(getScheduler()->getMutex());
    if (m_camOn)
    {
        m_closeCameraRequested = true;

        if (getState() == RECORD)
        {
            changeState(RECORD_PAUSE);
        }
        resume();
        emit allowedChanged();
    }
}

void CameraTask::execute()
{
    int currentState = getState();
    if (currentState == PAUSE)
    {
        return;
    }

    if (m_openCameraRequested)
    {
        bool isOpen = m_cameraNode->openCamera();
        QMutexLocker locker(getScheduler()->getMutex());
        setCamOn(isOpen);
        m_openCameraRequested = false;
        emit allowedChanged();
    }

    if (m_closeCameraRequested)
    {
        m_cameraNode->closeCamera();
        QMutexLocker locker(getScheduler()->getMutex());
        m_closeCameraRequested = false;
        setCamOn(false);
        emit allowedChanged();
    }

    if (currentState == PLAY)
    {
        VideoTask::execute();
    }
    else
    {
        if (currentState == STOP)
        {
            if (m_finalizeRecording)
            {
                QMutexLocker locker(getScheduler()->getMutex());
                setAmountOfFrames(getFrameId());
                updateFrameId(0);
                // clear savePoints so cancelling is not allowed anymore
                m_savePoints.clear();
                m_finalizeRecording = false;
                m_hasRecordedFrames = true;

                // lock node to prevent attribute changes and cache clearing
                m_node->lock();

                emit allowedChanged();
            }
        }

        if (m_camOn)
        {
            setOffset();

            if (!startProcess(m_node))
            {
                cancel();
                return;
            }

            handleFps(m_inputNode);

            if (currentState == RECORD)
            {
                // get the first outPort from behind and cache the result
                // works as long as m_node is a view node
                Port* outPort = m_node->getInPort(0)->getConnectedPort();
                outPort->cacheResult(getFrameId());

                updateFrameId(getFrameId() + 1);
            }
        }
        else
        {
            suspend();
        }
    }
}

bool CameraTask::process(Node* node, Port* fromPort, Port* toPort)
{
    if (getState() == PLAY)
    {
        return VideoTask::process(node, fromPort, toPort);
    }

    if (isSuspendRequested() || isCancelRequested())
    {
        return true;
    }

    if (!startProcess(node))
    {
        return false;
    }

    forwardResult(fromPort, toPort);
    return true;
}

void CameraTask::onCancelled()
{
    ImageTask::onCancelled();
    m_cameraNode->closeCamera();
    clearRecordedFrames();
}

void CameraTask::setCamOn(const bool& value)
{
    if (m_camOn != value)
    {
        m_camOn = value;
        emit camOnChanged();
    }
}

} // namespace G
