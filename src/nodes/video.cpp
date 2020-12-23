#include "video.h"
#include "imageconverter.h"
#include <QThread>
#include <QDateTime>

Video::Video()
{
    registerAttribute("path", new NodePathAttribute("\"Video files (*.mp4)\", \"All files (*)\""));
    registerAttribute("frame", new NodeRangeAttribute(0));
    registerAttribute("fps", new NodeDoubleAttribute(0.0, 144.0, 0.0));

    m_inPortCount = 0;
    m_nodeName = "Video";
}

Video::~Video()
{
    m_capture.release();
}




bool Video::retrieveResult() {
    if(getAttributeValue("path").toString() == ""){
        m_attributes.value("frame")->setConstraintValue("maxValue", QVariant(0));
        emit attributeValuesUpdated();
        m_path = "";
        return false;
    }
    if(m_path != getAttributeValue("path").toString()){
        m_path = getAttributeValue("path").toString();
        if(!startVideo()){
            return false;
        }
    }

    if(!m_capture.isOpened()){
        return false;
    }
    cv::Mat rawFrame;

    m_currentFrame = getAttributeValue("frame").toInt();

    m_capture.set(CV_CAP_PROP_POS_FRAMES, m_currentFrame);
    m_capture.read(rawFrame);
    m_img.setImage(rawFrame);
    m_vid[m_currentFrame] = m_img;

    return true;
}


bool Video::startVideo()
{
    m_capture.release();
    try {
        m_capture.open(m_path.toStdString());
    }  catch (...) {
        return false;
    }

    cleanCache();
    if(m_capture.isOpened()) {
        m_amountOfFrames = m_capture.get(CV_CAP_PROP_FRAME_COUNT);
        m_amountOfFrames -= 2;
        m_vid.fill(GImage(), m_amountOfFrames);
        m_currentFrame = 0;
        m_attributes.value("frame")->setConstraintValue("maxValue", QVariant(m_amountOfFrames));
        setAttributeValue("frame", m_currentFrame);
        double fps = m_capture.get(CV_CAP_PROP_FPS);
        setAttributeValue("fps", QVariant(fps));
        m_attributes.value("fps")->setDefaultValue(QVariant(fps));
        emit attributeValuesUpdated();
        return true;
    }
    m_attributes.value("frame")->setConstraintValue("maxValue", QVariant(0));
    emit attributeValuesUpdated();
    return false;
}

void Video::setAttributeValue(QString attributeName, QVariant value)
{
    if(m_attributes.contains(attributeName)){
        NodeAttribute* attr = m_attributes.value(attributeName);

        if(attr->getValue() != value){
            if(attributeName == "frame"){
                if(value.toInt() >= m_amountOfFrames){
                   value = QVariant(0);
                }
            }
            if(attributeName == "path"){
                setAttributeValue("frame", QVariant(0));
                m_attributes.value("frame")->setConstraintValue("maxValue", QVariant(0));
                setAttributeValue("fps", QVariant(0));
                m_attributes.value("fps")->setDefaultValue(QVariant(0));
                cleanCache();
            }
            attr->setValue(value);
            emit attributeValuesUpdated();
        }

    } else {
        qDebug() << "an attribute with this name does not exist!";
        throw "an attribute with this name does not exist!";
    }
}
