#ifndef WORKER_H
#define WORKER_H

#include <QObject>
#include <QDebug>
#include <QDateTime>
#include <QQueue>

#include "node.h"



class Worker : public QObject
{
    Q_OBJECT

public:
    Worker(QObject* parent = nullptr);

    void writeVideoFile(QString outputPath, Node* node);

signals:

    void finishedWritingVideoFile(bool status);

};


#endif // WORKER_H
