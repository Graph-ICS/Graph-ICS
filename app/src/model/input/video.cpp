#include "video.h"

#include <opencv2/videoio.hpp>

#include <QDateTime>
#include <QThread>

namespace G
{

Video::Video()
    : Node("Video", INPUT)
    , m_outPort(Port::TYPE::GIMAGE)
    , m_acceptedFiles({".mp4", ".avi"})
    , m_path(attributeFactory.makePathTextField("", m_acceptedFiles, "Video"))
    , m_fps(attributeFactory.makeDoubleTextField(0.0f, 0.0f, 144.0f, "FPS"))
    , m_capture()
    , m_amountOfFrames(0)
    , m_frameId(0)
{
    m_fps->forceDisableLocking();

    registerPorts({}, {&m_outPort});
    registerAttribute("path", m_path);
    registerAttribute("fps", m_fps);
}

Video::~Video()
{
    m_capture.release();
}

bool Video::retrieveResult()
{
    if (!m_capture.isOpened())
    {
        if (!openVideo())
        {
            return false;
        }
    }

    cv::Mat rawFrame;

    // calculate ms timestamp from frameId
    double ms = m_frameId / m_fpms;

    m_capture.set(cv::CAP_PROP_POS_FRAMES, m_frameId);
    m_capture.read(rawFrame);

    if (rawFrame.empty())
    {
        qDebug() << "Video: Read empty frame!";
        return true;
    }

    m_outPort.getGImage()->setImage(rawFrame);
    return true;
}

QList<QString> Video::getAcceptedFiles() const
{
    return m_acceptedFiles;
}

void Video::onAttributeValueChanged(Attribute* attribute)
{
    if (attribute == m_path)
    {
        // only clear cache on path change
        clearStreamCache();

        m_fps->setValue(0);
        m_amountOfFrames = 0;
        m_frameId = 0;
        m_capture.release();
    }
}

bool Video::openVideo()
{
    if (m_capture.isOpened())
    {
        return true;
    }

    QString path = m_path->getValue().toString();

    if (path == "")
    {
        qDebug() << "Video::openVideo: Path is empty!";
        return false;
    }

    try
    {
        m_capture.open(path.toStdString(), cv::CAP_ANY);
    }
    catch (const cv::Exception& e)
    {
        qDebug() << e.what();
        return false;
    }

    if (!m_capture.isOpened())
    {
        return false;
    }

    qDebug() << "Video: Opened Video with: " + QString::fromStdString(m_capture.getBackendName());

    // opencv requires to grab at least one frame before getting properties
    cv::Mat tmp;
    m_capture >> tmp;

    m_amountOfFrames = m_capture.get(cv::CAP_PROP_FRAME_COUNT);
    double fps = m_capture.get(cv::CAP_PROP_FPS);
    m_fpms = fps / 1000;

    if (m_fps->getValue().toDouble() == 0.0f)
    {
        m_fps->setValue(fps);
    }
    return true;
}

int Video::getAmountOfFrames() const
{
    return m_amountOfFrames;
}

int Video::getFrameId() const
{
    return m_frameId;
}

void Video::setFrameId(const int& frameId)
{
    m_frameId = frameId;
}
} // namespace G
