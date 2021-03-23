#ifndef GScheduler_H
#define GScheduler_H

#include <QThread>
#include <QMutex>
#include <QWaitCondition>
#include <QQueue>
#include <QDateTime>
#include "gtask.h"
#include "view.h"

class GScheduler : public QThread
{
    Q_OBJECT
public:
    GScheduler(QObject* parent = nullptr);
    ~GScheduler();

    Q_INVOKABLE void add(View* view, bool suspend);

    Q_INVOKABLE void stop();
    Q_INVOKABLE void suspend();
    Q_INVOKABLE void resume();

    Q_INVOKABLE void stopNode(Node* node);
    Q_INVOKABLE void suspendNode(Node* node);
    Q_INVOKABLE void resumeNode(Node* node);

protected:
    void run() override;

private:
    // Flags
    bool m_cancelled;
    bool m_suspended;

    QQueue<GTask> m_tasks;

    QMutex m_mutex;
    QMutex m_sleepMutex;
    QWaitCondition m_condition;
};

#endif // GScheduler_H
