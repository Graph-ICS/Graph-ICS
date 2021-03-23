#include "gtask.h"

#include <QDateTime>

GTask::GTask(View* view) :
    m_view(view),
    m_node(view->getConnectedNode()),
    m_inputNode(m_node->getInputNode())
{
        m_cancelled = false;
        m_suspended = false;
        m_offset = -1;
        m_interval = -1;
}

bool GTask::execute(){

    if(m_view == nullptr){
        m_cancelled = true;
        return false;
    }

    QStringList types;
    types << "GImage" << "GData";
    GImage resultImage;
    GData resultData;

    QVariant result;
    bool resultEmpty = false;

    QDateTime beginTS = QDateTime::currentDateTime();

    m_offset = beginTS.toMSecsSinceEpoch();

    switch (types.indexOf(m_node->getOutputType())) {
    case 0: // GImage
        resultImage = m_node->resultImage();

        if(resultImage.isEmpty()){
            resultEmpty = true;
        }
        result.setValue(resultImage.getQPixmap());
        break;

    case 1: // GData
        resultData = m_node->resultData();

        if(resultData.isEmpty()){
            resultEmpty = true;
        }
        result.setValue(resultData.getData());
        break;
    }

    if(m_view == nullptr){
        m_cancelled = true;
        return false;
    }

    if(m_view->getConnectedNode() != m_node){
        m_cancelled = true;
        return false;
    }

    if(resultEmpty){
        m_cancelled = true;
        emit m_view->printMessageForNode("The calculation delivered an empty result!");
    } else {
        emit m_view->updateView(result);

        QDateTime endTS = QDateTime::currentDateTime();
        if(m_inputNode->isCyclicProcessing()){
            if(m_inputNode->hasAttribute("fps")){
                double fps = m_inputNode->getAttributeValue("fps").toDouble();
                if(fps == 0){
                    m_interval = -1;
                    m_cancelled = true;
                } else {
                    m_interval = 1000/fps;
                }
            }
        } else {
            m_cancelled = true;
        }

    }

    if(m_cancelled){
        emit m_view->stopTask();
        return false;
    }

    return true;
}

Node *GTask::node() const
{
    return m_node;
}

Node *GTask::inputNode() const
{
    return m_inputNode;
}

bool GTask::isCancelled() const
{
    return m_cancelled;
}

bool GTask::isSuspended() const
{
    return m_suspended;
}

qint64 GTask::offset() const
{
    return m_offset;
}

qint64 GTask::interval() const
{
    return m_interval;
}

void GTask::setInterval(const qint64 &interval)
{
    m_interval = interval;
}


qint64 GTask::getTimeToNextTriggerTime()
{
    if(m_offset == -1 || m_interval == -1){
        return -1;
    }
    qint64 currentTime = QDateTime::currentMSecsSinceEpoch();
//    return m_interval - ((currentTime - m_offset) % m_interval);
    return m_offset + m_interval - currentTime;
}

void GTask::stopTask()
{
    m_cancelled = true;

    if(m_view == nullptr){
        return;
    }

    if(m_view->getConnectedNode() != m_node){
        return;
    }

    emit m_view->stopTask();
}

void GTask::cancel()
{
    m_cancelled = true;
}

void GTask::suspend()
{
    m_suspended = true;
}

void GTask::resume()
{
    m_suspended = false;
}

void GTask::setOffset(const qint64 &offset)
{
    m_offset = offset;
}
