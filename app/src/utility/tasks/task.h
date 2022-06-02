#ifndef Task_H
#define Task_H

#include <QDebug>
#include <QMutexLocker>
#include <QObject>

#include "scheduler.h"

namespace G
{

class Task : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isSuspended READ isSuspended NOTIFY suspendedChanged)

public:
    Task();
    virtual ~Task();

    Scheduler* getScheduler() const;
    void setScheduler(Scheduler* scheduler);

    /*!
     * \brief Should be called before cancel() to check if data could be lost after cancellation.
     * \return
     */
    Q_INVOKABLE virtual bool isCancelAllowed();
    Q_INVOKABLE int getCancelNotAllowedReason() const;
    /*!
     * \brief Removes the Task from the Scheduler queue.
     */
    Q_INVOKABLE void cancel();
    Q_INVOKABLE void suspend();
    Q_INVOKABLE void resume();

    Q_INVOKABLE bool isCancelled() const;
    Q_INVOKABLE bool isSuspended() const;

    /*!
     * \brief Returns the timestamp for the next execution.
     * \return Returns -1 if offset or interval is -1, otherwise returns offset + interval.
     */
    qint64 getNextTriggerTime();
    /*!
     * \brief Set the offset to the current date time.
     */
    void setOffset();
    void setOffset(const qint64& offset);
    void setInterval(const qint64& interval);

    /*!
     * \brief Updates the suspended and cancelled flags and can be overriden to add flags/states, but should be
     * called in the overide (e.g. Task::update();)
     */
    virtual void update();
    /*!
     * \brief Called in the GScheduler instance. GScheduler releases the mutex before calling this function and
     * aquires the mutex after completion.
     */
    virtual void execute() = 0;

signals:
    void allowedChanged();

    void cancelled();
    void suspended();
    void resumed();
    void suspendedChanged();

protected:
    bool isCancelRequested() const;
    bool isSuspendRequested() const;

    virtual void onCancelled();
    virtual void onSuspended();
    virtual void onResumed();

    int m_cancelNotAllowedReason;

private:
    Scheduler* m_scheduler;

    bool m_cancelled;
    bool m_requestedCancelledValue;
    bool m_suspended;
    bool m_requestedSuspendedValue;

    qint64 m_offset;
    qint64 m_interval;
};

} // namespace G

#endif // Task_H
