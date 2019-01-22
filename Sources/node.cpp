#include "node.h"

#include <QDebug>

Node::Node()
    : m_img(1, 1)
{
    m_img.fill(Qt::transparent);
}

QQmlListProperty<Node> Node::getInNodes()
{
    return QQmlListProperty<Node>(this, this,
             &Node::addInNode,
             &Node::getInNodeCount,
             &Node::getInNode,
             &Node::clearInNodes);
}

void Node::addInNode(Node* node) {
    m_inNodes.append(node);
    m_img = QPixmap();

    emit inNodesChanged();
}

int Node::getInNodeCount() const
{
    return m_inNodes.count();
}

Node *Node::getInNode(int index) const
{
    return m_inNodes.at(index);
}

void Node::removeInNode(Node* node) {
    m_inNodes.removeOne(node);
    m_img = QPixmap();

    emit inNodesChanged();
}

void Node::cleanCache()
{
    if(m_outNodes.size() > 0){
        for (int i = 0; i < m_outNodes.size(); ++i) {
            m_outNodes.at(i)->cleanCache();
        }
    }
    m_img = QPixmap();
}

void Node::clearInNodes() {

    if (getInNodeCount() > 0) {
        m_inNodes.clear();
        emit inNodesChanged();
    }
}


void Node::addInNode(QQmlListProperty<Node>* list, Node* p) {
    reinterpret_cast< Node* >(list->data)->addInNode(p);
}

void Node::clearInNodes(QQmlListProperty<Node>* list) {
    reinterpret_cast< Node* >(list->data)->clearInNodes();
}

Node* Node::getInNode(QQmlListProperty<Node>* list, int index) {
    return reinterpret_cast< Node* >(list->data)->getInNode(index);
}

int Node::getInNodeCount(QQmlListProperty<Node>* list) {
    return reinterpret_cast< Node* >(list->data)->getInNodeCount();
}


void Node::addOutNode(Node* node) {
    m_outNodes.append(node);

    emit outNodesChanged();
}

int Node::getOutNodeCount() const
{
    return m_outNodes.count();
}

Node* Node::getOutNode(int index) const
{
    return m_outNodes.at(index);
}


void Node::removeOutNode(Node* node) {
    m_outNodes.removeOne(node);
    emit outNodesChanged();
}

void Node::clearOutNodes() {
    if (getOutNodeCount() > 0) {
        m_outNodes.clear();
        emit outNodesChanged();
    }
}

QPixmap Node::getResult()
{
    if (!retrieveResult()) {
        m_img = QPixmap();
    }

    return m_img;
}

void Node::addOutNode(QQmlListProperty<Node>* list, Node* p) {
    reinterpret_cast< Node* >(list->data)->addOutNode(p);
}

void Node::clearOutNodes(QQmlListProperty<Node>* list) {
    reinterpret_cast< Node* >(list->data)->clearOutNodes();
}

Node* Node::getOutNode(QQmlListProperty<Node>* list, int index) {
    return reinterpret_cast< Node* >(list->data)->getOutNode(index);
}

int Node::getOutNodeCount(QQmlListProperty<Node>* list) {
    return reinterpret_cast< Node* >(list->data)->getOutNodeCount();
}

