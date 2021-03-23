#include "view.h"

View::View(QObject *parent) :
    QObject(parent),
    m_hasConnection(false)
{

}

void View::connectNode(Node* node){
    m_connectedNode = node;
    m_hasConnection = true;
}

void View::removeConnection(){
    m_connectedNode = nullptr;
    m_hasConnection = false;
}

bool View::hasConnection(){
    return m_hasConnection;
}

Node* View::getConnectedNode(){
    return m_connectedNode;
}
