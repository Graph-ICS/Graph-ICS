#include "fileio.h"
#include <QFile>
#include <QTextStream>
#include "gimage.h"


FileIO::FileIO(QObject *parent) :
    QObject(parent)
{

}

QString FileIO::openFile(QString url)
{
    QString res = "";
    QFile file(url);
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text)){
        return res;
    }
    QTextStream in(&file);
    while(!in.atEnd()){
        res  += in.readLine();
        res += "\n";
    }
    return res;
}

void FileIO::saveFile(QString text, QString url)
{
    QFile file(url);
    if(!file.open(QIODevice::WriteOnly | QIODevice::Text)){
        return;
    }
    QTextStream out(&file);
    out << text;
}

void FileIO::writeVideoFile(QString outputPath, Node *node)
{
    if(outputPath.startsWith("file")){
        outputPath.remove(0, PATHOVERHEAD);
    }
    m_path = outputPath;
    m_node = node;

    m_thread = new QThread();
    m_worker = new Worker();

    m_worker->moveToThread(m_thread);

    QObject::connect(m_thread, &QThread::started, m_worker, [=]{
        m_worker->writeVideoFile(outputPath, node);
    });
    QObject::connect(m_worker, &Worker::finishedWritingVideoFile, this, &FileIO::videoExported);
    QObject::connect(m_worker, &Worker::finishedWritingVideoFile, m_thread, &QThread::quit);
    QObject::connect(m_thread, &QThread::finished, m_worker, &Worker::deleteLater);
    QObject::connect(m_thread, &QThread::finished, m_thread, &QThread::deleteLater);

    m_thread->start();
}


void FileIO::writeImageFile(QString outputPath, Node *node)
{
    outputPath.remove(0, PATHOVERHEAD);
    auto img = node->getResult();
    img.getQImage().save(outputPath);
}

QString FileIO::removePathoverhead(QString outputPath)
{
    return outputPath.remove(0, PATHOVERHEAD);
}

