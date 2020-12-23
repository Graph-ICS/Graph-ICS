#ifndef WORKER_H
#define WORKER_H

#include <QObject>
#include <QDebug>
#include <QDateTime>
#include <QQueue>

#include "gimage.h"
#include "node.h"



class Worker : public QObject
{
    Q_OBJECT

public:
    Worker(QObject* parent = nullptr);
    bool processVideo(Node* node, Node* inputNode);
    bool processCamera(Node* node, Node* inputNode);
    bool processImage(Node* node);

    void writeVideoFile(QString outputPath, Node* node);

signals:
    void imageProcessed(const GImage&);
    void videoFrameProcessed(const GImage&);

    void finishedWritingVideoFile(bool status);
};


#endif // WORKER_H
