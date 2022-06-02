#include "task.h"

#include "scheduler.h"

#include <QDateTime>

namespace G
{

Task::Task()
    : QObject()
    , m_cancelNotAllowedReason(-1)
    , m_scheduler(nullptr)
    , m_cancelled(false)
    , m_requestedCancelledValue(false)
    , m_suspended(true)
    , m_requestedSuspendedValue(true)
    , m_offset(-1)
    , m_interval(-1)
{
}

Task::~Task()
{
    deleteLater();
}

Scheduler* Task::getScheduler() const
{
    Q_ASSERT(m_scheduler != nullptr);
    return m_scheduler;
}

void Task::setScheduler(Scheduler* scheduler)
{
    m_scheduler = scheduler;
}

void Task::cancel()
{
    QMutexLocker locker(m_scheduler->getMutex());
    m_requestedCancelledValue = true;
    m_scheduler->wakeUp();
}

void Task::suspend()
{
    QMutexLocker locker(m_scheduler->getMutex());
    m_requestedSuspendedValue = true;
    m_scheduler->wakeUp();
}

void Task::resume()
{
    QMutexLocker locker(m_scheduler->getMutex());
    m_requestedSuspendedValue = false;
    m_scheduler->wakeUp();
}

bool Task::isCancelAllowed()
{
    return true;
}

int Task::getCancelNotAllowedReason() const
{
    return m_cancelNotAllowedReason;
}

bool Task::isCancelled() const
{
    return m_cancelled;
}

bool Task::isSuspended() const
{
    return m_suspended;
}

qint64 Task::getNextTriggerTime()
{
    QMutexLocker locker(m_scheduler->getMutex());
    if (m_offset == -1 || m_interval == -1)
    {
        return -1;
    }

    return m_offset + m_interval;
}

void Task::setOffset()
{
    QMutexLocker locker(m_scheduler->getMutex());
    m_offset = QDateTime::currentMSecsSinceEpoch();
}

void Task::setOffset(const qint64& offset)
{
    QMutexLocker locker(m_scheduler->getMutex());
    m_offset = offset;
}

void Task::setInterval(const qint64& interval)
{
    QMutexLocker locker(m_scheduler->getMutex());
    m_interval = interval;
}

void Task::update()
{
    QMutexLocker locker(m_scheduler->getMutex());
    if (m_cancelled != m_requestedCancelledValue)
    {
        m_cancelled = m_requestedCancelledValue;
        if (m_cancelled)
        {
            onCancelled();
            emit cancelled();
        }
    }
    if (m_suspended != m_requestedSuspendedValue)
    {
        m_suspended = m_requestedSuspendedValue;
        if (m_suspended)
        {
            onSuspended();
            emit suspended();
        }
        else
        {
            onResumed();
            emit resumed();
        }
        emit suspendedChanged();
    }
}

bool Task::isCancelRequested() const
{
    return m_requestedCancelledValue;
}

bool Task::isSuspendRequested() const
{
    return m_requestedSuspendedValue;
}

void Task::onCancelled()
{
}

void Task::onSuspended()
{
}

void Task::onResumed()
{
}

} // namespace G
