#ifndef FILEIO_H
#define FILEIO_H

#include <QObject>
#include <QFile>
#include <QThread>
#include "node.h"
#include "worker.h"

#ifdef __linux__
    #define PATHOVERHEAD 7
#else //__WIN32__
    #define PATHOVERHEAD 8
#endif

class FileIO : public QObject
{
    Q_OBJECT
public:
    explicit FileIO(QObject *parent = nullptr);

    Q_INVOKABLE QString openFile(QString url);
    Q_INVOKABLE void saveFile(QString text, QString url);

    Q_INVOKABLE void writeVideoFile(QString outputPath, Node* node);
    Q_INVOKABLE void writeImageFile(QString outputPath, Node* node);

    Q_INVOKABLE QString removePathoverhead(QString outputPath);

signals:
    void videoExported(bool status);

private:
    QThread* m_thread;
    Worker* m_worker;

    QString m_path;
    Node* m_node;

};

#endif // FILEIO_H
