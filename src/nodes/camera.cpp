#include "camera.h"
#include "imageconverter.h"

int Camera::m_instances = -1;

Camera::Camera()
{
    m_nodeName = "Camera";
    m_inPortCount = 0;
    registerAttribute("fps", new NodeDoubleAttribute(0.0, 144, 0.0));
//    registerAttribute("number", new NodeIntAttribute(0, 10));

    m_instanceNumber = m_instances;
    m_instances++;
    m_warningMessage = "Open Capture " + QString::number(m_instanceNumber);
    m_cyclicProcessing = true;
}

Camera::~Camera()
{
    m_capture.release();
    m_instances--;
}


bool Camera::retrieveResult()
{
    if(!m_capture.isOpened()){
        bool value = m_capture.open(m_instanceNumber);
        if(value){
            double fps = m_capture.get(CV_CAP_PROP_FPS);
            if(getAttributeValue("fps").toDouble() == 0){
                setAttributeValue("fps", QVariant(fps));
            }
//            m_attributes.value("fps")->setDefaultValue(QVariant(fps));
        }
    }
    if(m_capture.isOpened()){
        cv::Mat rawFrame;
        m_capture.read(rawFrame);
        m_img.setImage(rawFrame);
        return true;
    }
    return false;
}

bool Camera::inputType(Node* startNode)
{
    cleanCache();
    bool val = startNode->retrieveResult();
    return val;
}
