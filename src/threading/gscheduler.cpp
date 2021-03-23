#include "gscheduler.h"

#include <QMutexLocker>
#include <QtConcurrent>
#include <QFuture>
#include <QSet>
#include <algorithm>
#include <math.h>

GScheduler::GScheduler(QObject* parent) :
    QThread(parent),
    m_tasks(QQueue<GTask>()),
    m_mutex(),
    m_sleepMutex(),
    m_condition()
{
    m_cancelled = false;
    m_suspended = false;
}

GScheduler::~GScheduler(){
    m_mutex.lock();
    m_cancelled = true;
    m_tasks.clear();
    m_mutex.unlock();
    m_condition.wakeOne();
    wait();
}

void GScheduler::add(View* view, bool suspend){

    GTask task(view);
    if(suspend){
        task.suspend();
    }

    m_mutex.lock();
    m_tasks.enqueue(task);
    m_mutex.unlock();

    if(isRunning()){
        m_condition.wakeOne();
    } else {
        start();
    }
}

void GScheduler::stop(){
    QMutexLocker locker(&m_mutex);
    m_cancelled = true;
    m_condition.wakeOne();
}

void GScheduler::suspend(){
    QMutexLocker locker(&m_mutex);
    for(int i = 0; i < m_tasks.size(); i++){
        m_tasks[i].suspend();
    }
}

void GScheduler::resume(){
    QMutexLocker locker(&m_mutex);
    for(int i = 0; i < m_tasks.size(); i++){
        m_tasks[i].resume();
    }
    m_condition.wakeOne();
}

void GScheduler::stopNode(Node *node)
{
    QMutexLocker locker(&m_mutex);
    for(int i = 0; i < m_tasks.size(); i++){
        GTask* task = &m_tasks[i];
        if(task->node() == node){
            task->cancel();
            break;
        }
    }
    m_condition.wakeOne();
}

void GScheduler::suspendNode(Node *node)
{
    QMutexLocker locker(&m_mutex);
    for(int i = 0; i < m_tasks.size(); i++){
        GTask* task = &m_tasks[i];
        if(task->node() == node){
            task->suspend();
            break;
        }
    }
}

void GScheduler::resumeNode(Node *node)
{
    QMutexLocker locker(&m_mutex);
    for(int i = 0; i < m_tasks.size(); i++){
        GTask* task = &m_tasks[i];
        if(task->node() == node){
            task->resume();
            break;
        }
    }
    m_condition.wakeOne();
}

void GScheduler::run() {
    while(true){

        qint64 sleepTime = -1;
        bool firstRun = true;
        int suspendCounter = 0;
        int i = 0;
        while(i < m_tasks.size()){

            GTask* currentTask = &m_tasks[i];

            if(currentTask->isCancelled()){
                m_mutex.lock();
                currentTask->stopTask();
                m_tasks.removeAt(i);
                m_mutex.unlock();
                continue;
            }

            if(currentTask->isSuspended()){
                suspendCounter++;
            } else {

                qint64 timeToNextTriggerTime = currentTask->getTimeToNextTriggerTime();

                if(firstRun){
                    sleepTime = timeToNextTriggerTime;
                    firstRun = false;
                }
                if(timeToNextTriggerTime < sleepTime){
                    sleepTime = timeToNextTriggerTime;
                }

                if(timeToNextTriggerTime <= 0){
                    currentTask->execute();
                }

            }

            i++;
        }

        if(m_tasks.isEmpty()){
            return;
        }

        if(suspendCounter >= m_tasks.size()){
            m_mutex.lock();
            m_condition.wait(&m_mutex);
            m_mutex.unlock();
            sleepTime = -1;
        }

        if(m_cancelled){
            m_mutex.lock();
            for(auto task : m_tasks){
                task.stopTask();
            }
            m_tasks.clear();
            m_cancelled = false;
            m_mutex.unlock();
            return;
        }

        if(sleepTime > 0){
            m_sleepMutex.lock();
            m_condition.wait(&m_sleepMutex, sleepTime);
            m_sleepMutex.unlock();
        }

    }
}
