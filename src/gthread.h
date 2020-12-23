#ifndef GTHREAD_H
#define GTHREAD_H

#include <QThread>
#include <QMutex>
#include <QWaitCondition>
#include <QQueue>

#include "node.h"
#include "worker.h"

class GThread : public QThread
{
    Q_OBJECT
public:
    GThread(QObject* parent = nullptr);
    ~GThread();

    Q_INVOKABLE void add(Node* node);
    void suspend();
    void resume();

    Q_INVOKABLE void stopVideo();
    Q_INVOKABLE void playVideo();
    Q_INVOKABLE void pauseVideo();

    Q_INVOKABLE void emptyQueue();
    Q_INVOKABLE void removeNodeAt(int index);

signals:
    void imageProcessed(const GImage& result);
    void videoFrameProcessed(const GImage& result);

protected:
    void run() override;

private:
    QQueue<Node*> m_queue;
    Worker* m_worker;

    QMutex m_mutex;
    QWaitCondition m_condition;

    bool m_abort = false;

    // Flags
    bool m_suspend = false;
    bool m_emptyQueue = false;
    bool m_stop = false;

    bool m_videoPlaying = false;
};

#endif // GTHREAD_H
