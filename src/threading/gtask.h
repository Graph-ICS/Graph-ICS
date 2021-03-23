#ifndef GTASK_H
#define GTASK_H

#include "view.h"
#include <QQueue>

class GTask
{
public:
    GTask(View* view);

    bool execute();

    Node *node() const;
    Node *inputNode() const;

    bool isCancelled() const;
    bool isSuspended() const;

    qint64 offset() const;
    void setOffset(const qint64 &offset);

    qint64 interval() const;
    void setInterval(const qint64 &interval);

    qint64 getTimeToNextTriggerTime();

    void stopTask();

    void cancel();
    void suspend();
    void resume();

private:
    View* m_view;
    Node* m_node;
    Node* m_inputNode;

    bool m_cancelled;
    bool m_suspended;

    qint64 m_offset;
    qint64 m_interval;
};

#endif // GTASK_H
