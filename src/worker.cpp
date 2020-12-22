#include "worker.h"

#include <QThread>


#include <opencv2/core.hpp>
#include <opencv2/videoio.hpp>

Worker::Worker(QObject* parent) :
    QObject(parent)
{

}


bool Worker::processVideo(Node* node, Node* inputNode){

    QDateTime timeStamp1 = QDateTime::currentDateTime();

    auto result = node->getResult();
    if(result.isSet()){
        emit videoFrameProcessed(result);
    } else {
        return false;
    }

    if(inputNode->getAttributeValue("fps").toDouble() == 0){
        return false;
    }

    if(inputNode->hasAttribute("frame")){
        // Video Specific
        int currFrame = inputNode->getAttributeValue("frame").toInt();
        currFrame++;
        inputNode->setAttributeValue("frame", QVariant(currFrame));
    }

    QDateTime timeStamp2 = QDateTime::currentDateTime();
    // timestamp Difference
    qint64 diff = timeStamp1.msecsTo(timeStamp2);
    // Calculate time 1 Frame needs to be played
    qint64 ms = 1000/inputNode->getAttributeValue("fps").toDouble();
    if(diff < ms){
        // wait
        QThread::currentThread()->msleep(ms - diff);
    }
    return true;
}

bool Worker::processImage(Node* node){
    auto result = node->getResult();
    emit imageProcessed(result);
    return result.isSet();
}

void Worker::writeVideoFile(QString outputPath, Node *node)
{
    Node* inputNode = node->getInputNode();

    cv::VideoWriter videoWriter;
    auto vid = node->getVideo();

    if(vid.isEmpty()){
        emit finishedWritingVideoFile(false);
        return;
    }

    int codec = cv::VideoWriter::fourcc('m', 'p', '4', 'v');
    int fps = 24;

    if(inputNode->hasAttribute("fps")){
        fps = inputNode->getAttributeValue("fps").toInt();
    }

    GImage frame = vid.at(0);

    auto mat = frame.getCvMatImage();
    cv::Size size = mat.size();

    bool color = false;
    if(mat.type() == CV_8UC3){
        color = true;
    }
    videoWriter.open(outputPath.toStdString(), codec, fps, size, color);

    for(auto i : vid){
        videoWriter.write(i.getCvMatImage());
    }

    videoWriter.release();
    emit finishedWritingVideoFile(true);
}

//void Worker::processQueue()
//{
//    while(!m_nodeQueue->empty()) {

//        Node* node = m_nodeQueue->dequeue();

//        // Flag Abfrage
//        if(m_emptyQueue){
//            m_nodeQueue->clear();
//            emit nodeProcessed(node->getResult());
//            continue;
//        }

//        Node* inputNode = node->getInputNode();

//        if(inputNode->getNodeName() == "Video" || inputNode->getNodeName() == "Camera"){

//            QDateTime timeStamp1 = QDateTime::currentDateTime();
//            if(!m_stop){
//                m_nodeQueue->prepend(node);
//                emit videoFrameProcessed(node->getResult());
//            } else {
//                emit nodeProcessed(node->getResult());
//            }


//            if(m_play){
//                if(inputNode->hasAttribute("frame")){
//                    int currFrame = inputNode->getAttributeValue("frame").toInt();
//                    currFrame++;
//                    inputNode->setAttributeValue("frame", QVariant(currFrame));
//                }
//            }
//            if(inputNode->hasAttribute("fps")){
//                QDateTime timeStamp2 = QDateTime::currentDateTime();
//                // differenz der Zeitstempel
//                qint64 diff = timeStamp1.msecsTo(timeStamp2);
//                // 1 Frame braucht ms millisekunden Zeit um abgespielt zu werden
//                // falls diff kleiner muss der Thread warten bis ms erreicht ist
//                qint64 ms = 1000/inputNode->getAttributeValue("fps").toDouble();
//                if(diff < ms){
//                    QThread::currentThread()->msleep(ms - diff);
//                }
//            }
//        } else {
//            // Standard Behandlung fuer ein Input Image
//            emit nodeProcessed(node->getResult());
//        }
//    }
//}


