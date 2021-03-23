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
    m_amountOfFrames = 0;
    m_cyclicProcessing = true;
    m_offset = -1;
    m_interval = -1;
}

Video::~Video()
{
    m_capture.release();
}

bool Video::retrieveResult() {
    if(getAttributeValue("path").toString() == ""){
        m_attributes.value("frame")->setConstraintValue("maxValue", QVariant(0));
        emit attributeValuesUpdated();
        return false;
    }

    if(!m_capture.isOpened()){
        if(!startVideo()){
            return false;
        }
    }

    cv::Mat rawFrame;

    m_currentFrame = getAttributeValue("frame").toInt();

    m_capture.set(CV_CAP_PROP_POS_FRAMES, m_currentFrame);
    m_capture.read(rawFrame);
    m_img.setImage(rawFrame);
    m_vid[m_currentFrame] = m_img;

    return true;
}

bool Video::inputType(Node* startNode)
{
    if(m_offset + m_interval <= QDateTime::currentMSecsSinceEpoch()){
        double fps = getAttributeValue("fps").toDouble();

        if(fps != 0){
            m_interval = 1000/fps;

            if(m_offset != -1){
                int frame = getAttributeValue("frame").toInt();
                frame++;
                setAttributeValue("frame", QVariant(frame));
            }
        }

        m_offset = QDateTime::currentMSecsSinceEpoch();
    }

    int currFrame = getAttributeValue("frame").toInt();
//    qDebug() << currFrame << startNode->getNodeName();
    if(!m_capture.isOpened()){
        if(!retrieveResult()){
            // failed
            return false;
        }
    }

//    m_img = m_vid[currFrame].deepCopy();

    if(startNode->m_vid.size() < m_vid.size()){
        startNode->m_vid.fill(GImage(), m_vid.size());
    }

    if(startNode->m_vid[currFrame].isEmpty()){
        if(!startNode->retrieveResult()){
            // failed
            return false;
        }
        startNode->m_vid[currFrame] = startNode->m_img.deepCopy();
    } else {
        startNode->m_img = startNode->m_vid[currFrame];
        return true;
    }

    bool isCached = true;

    for(int i = 0; i < startNode->m_vid.size(); i++){
        if(startNode->m_vid[i].isEmpty()){
            isCached = false;
//            qDebug() << i << startNode->getNodeName();
            break;
        }
    }

    if(isCached){
        emit startNode->cached(true);
    }
    return true;
}


bool Video::startVideo()
{
    try {
        m_path = getAttributeValue("path").toString();
        m_capture.open(m_path.toStdString());
    }  catch (...) {
        return false;
    }

    cleanCache();
    if(m_capture.isOpened()) {
        m_amountOfFrames = m_capture.get(CV_CAP_PROP_FRAME_COUNT);
        m_vid.fill(GImage(), m_amountOfFrames);
        m_currentFrame = 0;
        m_attributes.value("frame")->setConstraintValue("maxValue", QVariant(m_amountOfFrames));
        setAttributeValue("frame", m_currentFrame);
        double fps = m_capture.get(CV_CAP_PROP_FPS);
        if(getAttributeValue("fps").toDouble() == 0){
            setAttributeValue("fps", QVariant(fps));
        }
        m_attributes.value("fps")->setDefaultValue(QVariant(fps));
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
                if(value.toInt() > m_amountOfFrames-1){
                   value = QVariant(0);
                }
            }
            if(attributeName == "path"){
                setAttributeValue("frame", QVariant(0));
                m_attributes.value("frame")->setConstraintValue("maxValue", QVariant(0));
                setAttributeValue("fps", QVariant(0));
                m_attributes.value("fps")->setDefaultValue(QVariant(0));
                m_capture.release();
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
