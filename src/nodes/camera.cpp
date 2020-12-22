#include "camera.h"
#include "imageconverter.h"

Camera::Camera()
{
    m_nodeName = "Camera";
    m_inPortCount = 0;
    m_capture.open(0);
    double fps = m_capture.get(CV_CAP_PROP_FPS);
    registerAttribute("fps", new NodeDoubleAttribute(fps, fps, 0.0));
}

Camera::~Camera()
{
    m_capture.release();
}

bool Camera::retrieveResult()
{
    if(m_capture.isOpened()){
        cv::Mat rawFrame;
        m_capture.read(rawFrame);
        QImage img = ImageConverter::Mat2QImage(rawFrame);
        m_img.setImage(QPixmap::fromImage(img));
        return true;
    }
    return false;
}

