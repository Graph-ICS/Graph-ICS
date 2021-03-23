#include "worker.h"

#include <QThread>


#include <opencv2/core.hpp>
#include <opencv2/videoio.hpp>

Worker::Worker(QObject* parent) :
    QObject(parent)
{

}

void Worker::writeVideoFile(QString outputPath, Node *node)
{
    Node* inputNode = node->getInputNode();

    cv::VideoWriter videoWriter;
    auto vid = node->resultVideo();

    if(vid.isEmpty()){
        emit finishedWritingVideoFile(false);
        return;
    }

    int codec = cv::VideoWriter::fourcc('X', '2', '6', '4');
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
