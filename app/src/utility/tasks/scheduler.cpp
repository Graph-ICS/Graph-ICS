#include "scheduler.h"

#include "task.h"

#include <QDateTime>
#include <QDebug>
#include <QMutexLocker>

namespace G
{

Scheduler::Scheduler(QObject* parent)
    : QThread(parent)
    , m_cancelled(false)
    , m_suspended(false)
    , m_suspendedCounter(0)
    , m_tasks()
    , m_mutex()
    , m_conditionMutex()
    , m_condition()
{
}

Scheduler::~Scheduler()
{
    cancel();
    wait();
}

void Scheduler::add(Task* task)
{
    QMutexLocker locker(&m_mutex);
    if (m_tasks.indexOf(task) != -1)
    {
        qDebug() << "GScheduler::add: task already added!";
        return;
    }

    task->setScheduler(this);
    m_tasks.enqueue(task);

    if (isRunning())
    {
        m_condition.wakeOne();
    }
    else
    {
        start();
    }
}

void Scheduler::cancel()
{
    QMutexLocker locker(&m_mutex);
    m_cancelled = true;
    m_condition.wakeOne();
}

void Scheduler::suspend()
{
    QMutexLocker locker(&m_mutex);
    m_suspended = true;
}

void Scheduler::resume()
{
    QMutexLocker locker(&m_mutex);
    m_suspended = false;
    m_condition.wakeOne();
}

void Scheduler::wakeUp()
{
    QMutexLocker locker(&m_mutex);
    m_condition.wakeOne();
}

QRecursiveMutex* Scheduler::getMutex()
{
    return &m_mutex;
}

void Scheduler::run()
{
    while (true)
    {
        QMutexLocker locker(&m_mutex);
        if (m_cancelled)
        {
            while (!m_tasks.isEmpty())
            {
                Task* task = m_tasks.front();
                // cancel the task and call update, for Task::onCancelled() to be called
                task->cancel();
                task->update();
                remove(task);
            }
            return;
        }

        if (m_suspended || m_suspendedCounter == m_tasks.size())
        {
            // weird looking unlocks and locks need to be used because
            // QRecursiveMutex is not allowed in a QWaitCondition
            locker.unlock();
            m_conditionMutex.lock();
            m_condition.wait(&m_conditionMutex);
            m_conditionMutex.unlock();
            locker.relock();
        }

        m_suspendedCounter = 0;
        qint64 sleepTime = 0;
        int taskIndex = 0;

        // loop through all tasks
        while (taskIndex < m_tasks.size())
        {
            Task* currentTask = m_tasks[taskIndex];
            // update flags
            currentTask->update();

            if (currentTask->isCancelled())
            {
                remove(currentTask);
                // continue without incrementing taskIndex
                continue;
            }

            if (currentTask->isSuspended() || m_suspended)
            {
                m_suspendedCounter++;
            }
            else
            {
                sleepTime = taskIndex == 0 ? std::numeric_limits<qint64>::max() : sleepTime;
                qint64 currentTime = QDateTime::currentMSecsSinceEpoch();
                qint64 timeToNextTriggerTime = currentTask->getNextTriggerTime() - currentTime;

                if (timeToNextTriggerTime < sleepTime)
                {
                    sleepTime = timeToNextTriggerTime;
                }

                // execute only tasks that need execution
                if (timeToNextTriggerTime <= 0)
                {
                    locker.unlock();
                    currentTask->execute();
                    locker.relock();
                }
            }

            taskIndex++;
        }

        // let the thread sleep for the duration of sleepTime (ms)
        if (sleepTime > 0)
        {
            // unlock only, no relock needed because the scope of the locker ends
            locker.unlock();
            m_conditionMutex.lock();
            m_condition.wait(&m_conditionMutex, sleepTime);
            m_conditionMutex.unlock();
        }
    }
}

void Scheduler::remove(Task* task)
{
    m_tasks.removeOne(task);
    //    task->setScheduler(nullptr);
}

} // namespace G
