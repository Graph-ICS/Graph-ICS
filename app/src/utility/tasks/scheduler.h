#ifndef GScheduler_H
#define GScheduler_H

#include <QQueue>
#include <QRecursiveMutex>
#include <QThread>
#include <QWaitCondition>

namespace G
{

class Task;

class Scheduler : public QThread
{
    Q_OBJECT

public:
    Scheduler(QObject* parent = nullptr);
    ~Scheduler();

    Q_INVOKABLE void add(G::Task* task);

    Q_INVOKABLE void cancel();
    Q_INVOKABLE void suspend();
    Q_INVOKABLE void resume();

    void wakeUp();
    QRecursiveMutex* getMutex();

protected:
    void run() override;

private:
    void remove(Task* task);

    // Flags
    bool m_cancelled;
    bool m_suspended;
    int m_suspendedCounter;

    QQueue<Task*> m_tasks;

    QRecursiveMutex m_mutex;
    QMutex m_conditionMutex;
    QWaitCondition m_condition;
};

} // namespace G

#endif // GScheduler_H
