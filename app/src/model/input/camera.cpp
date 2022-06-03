#include "camera.h"

#include <opencv2/videoio.hpp>

namespace G
{

QVector<int> Camera::openCameraDevices = QVector<int>();

Camera::Camera()
    : Node("Camera", INPUT)
    , m_outPort(Port::TYPE::GIMAGE)
    , m_fps(attributeFactory.makeDoubleTextField(0.0f, 0.0f, 144.0f, "FPS"))
    , m_device(attributeFactory.makeIntTextField(0, 0, 100, 1, "Device"))
    , m_capture()
    , m_cameraOpenCounter(0)
{
    m_fps->forceDisableLocking();

    registerPorts({}, {&m_outPort});
    registerAttribute("device", m_device);
    registerAttribute("fps", m_fps);
}

Camera::~Camera()
{
    closeCamera(true);
}

bool Camera::retrieveResult()
{
    if (!isCameraDeviceOpen())
    {
        if (!openCamera())
        {
            return false;
        }
    }

    cv::Mat frame;
    m_capture.read(frame);
    m_outPort.getGImage()->setImage(frame);

    return true;
}

void Camera::onAttributeValueChanged(Attribute* attribute)
{
    if (attribute == m_fps)
    {
        return;
    }
    clearStreamCache();
}

bool Camera::isCameraDeviceOpen() const
{
    return m_capture.isOpened();
}

bool Camera::openCamera()
{
    if (!m_capture.isOpened())
    {
        int device = m_device->getValue().toInt();
        if (openCameraDevices.indexOf(device) != -1)
        {
            emit message("Camera device can not be opened! Another Camera Node already uses this device!");
            return false;
        }
        bool isOpened = m_capture.open(device);
        if (!isOpened)
        {
            emit message("Failed to open Camera device!");
            return false;
        }
        // read sample frame before getting fps
        cv::Mat sample;
        m_capture.read(sample);
        double fps = m_capture.get(cv::CAP_PROP_FPS);
        if (m_fps->getValue().toDouble() == 0.0f)
        {
            m_fps->setValue(fps);
        }
        openCameraDevices.push_back(device);
    }
    m_cameraOpenCounter++;
    return true;
}

void Camera::closeCamera(bool force)
{
    if (m_capture.isOpened())
    {
        m_cameraOpenCounter--;
        if (m_cameraOpenCounter == 0 || force)
        {
            m_capture.release();
            int device = m_device->getValue().toInt();
            openCameraDevices.removeOne(device);
        }
    }
}
} // namespace G
