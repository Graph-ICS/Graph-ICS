#include "gthread.h"

#include <QMutexLocker>


GThread::GThread(QObject* parent) :
    QThread(parent),
    m_queue(QQueue<Node*>()),
    m_worker(new Worker())
{
    m_worker->moveToThread(this);

    QObject::connect(m_worker, &Worker::imageProcessed, this, &GThread::imageProcessed);
    QObject::connect(m_worker, &Worker::videoFrameProcessed, this, &GThread::videoFrameProcessed);

}

GThread::~GThread(){
    m_mutex.lock();
    m_abort = true;
    m_mutex.unlock();
    m_condition.wakeOne();
    delete m_worker;
    wait();
}

void GThread::add(Node *node){
    QMutexLocker locker(&m_mutex);
    m_queue.enqueue(node);

    if(!isRunning()){
        start();
    } else {
        if(!m_suspend){
            m_condition.wakeOne();
        }
    }
}

void GThread::suspend(){
    QMutexLocker locker(&m_mutex);
    m_suspend = true;
}

void GThread::resume(){
    QMutexLocker locker(&m_mutex);
    m_suspend = false;
    m_condition.wakeOne();
}

void GThread::stopVideo(){
    m_mutex.lock();
    m_stop = true;
    m_mutex.unlock();
    resume();
}

void GThread::playVideo(){
    resume();
}

void GThread::pauseVideo(){
    suspend();
}

void GThread::emptyQueue(){
    QMutexLocker locker(&m_mutex);
    if(!m_queue.isEmpty()){
        Node* tmp = m_queue.first();
        m_queue.clear();
        if(m_videoPlaying){
            m_queue.enqueue(tmp);
        }
        m_condition.wakeOne();
    }
}

void GThread::removeNodeAt(int index)
{
    QMutexLocker locker(&m_mutex);
    if(m_queue.first()->getInputNodeName() != "Image"){
        index++;
    }
    m_queue.removeAt(index);
}

void GThread::run(){
    while(true){
        if(m_abort){
            return;
        }
        while(!m_queue.isEmpty()){
            if(m_abort){
                return;
            }
            // Flags
            if(m_suspend){
                break;
            }
            m_mutex.lock();
            Node* node = m_queue.dequeue();
            m_mutex.unlock();
            Node* inputNode = node->getInputNode();
            QStringList options;
            options << "Image" << "Camera" << "Video";

            switch(options.indexOf(inputNode->getNodeName())){
                case 0:
                    // Image
                    m_worker->processImage(node);
                    break;
                case 1:
                    // Camera
                    // Camera gets treated the same as Video
                case 2:
                    // Video
                    if(!m_stop){
                        m_mutex.lock();
                        m_queue.prepend(node);
                        m_videoPlaying = true;
                        m_mutex.unlock();
                        if(!m_worker->processVideo(node, inputNode)){
                            stopVideo();
                        }
                    } else {
                        m_mutex.lock();
                        m_videoPlaying = false;
                        m_mutex.unlock();

                        m_worker->processImage(node);

                        m_mutex.lock();
                        m_stop = false;
                        m_mutex.unlock();
                    }
                    break;
                default:
                    m_worker->processImage(node);
                    break;
            }
        }
        m_mutex.lock();
        m_condition.wait(&m_mutex);
        m_mutex.unlock();
    }
}
