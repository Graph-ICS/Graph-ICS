#include "node.h"
#include "worker.h"
#include "qqml.h"
#include <QDebug>

Node::Node() :
    m_inPortCount(1),
    m_nodeName(QString("")),
    m_warningMessage(QString("")),
    m_cyclicProcessing(false),
    m_outputType(QString("GImage"))
{

}

QQmlListProperty<Node> Node::getInNodes()
{
    return QQmlListProperty<Node>(this, this,
                                  &Node::addInNode,
                                  &Node::getInNodeCount,
                                  &Node::getInNode,
                                  &Node::clearInNodes);
}

QString Node::getInputNodeName()
{
    return getInputNode()->getNodeName();
}

Node *Node::getInputNode()
{
    Node* inputNode = this;
    while(inputNode->getInNodeCount() > 0){
        inputNode = inputNode->getInNode(0);
    }
    return inputNode;
}


void Node::addInNode(Node* node) {
    m_inNodes.append(node);
    m_img.clear();

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
    m_img.clear();

    emit inNodesChanged();
}

void Node::cleanCache()
{
    if(m_outNodes.size() > 0){
        for (int i = 0; i < m_outNodes.size(); ++i) {
            m_outNodes.at(i)->cleanCache();
        }
    }

    m_vid.clear();
    m_img.clear();
    m_data.clear();

    emit cached(false);
}

QVariant Node::getAttributeConstraint(QString attributeName, QString constraintName)
{
    if(m_attributes.contains(attributeName)){
        return m_attributes.value(attributeName)->getConstraint(constraintName);
    } else {
        qDebug() << "an attribute with the name \"" + attributeName + "\" does not exist!";
        throw "an attribute with the name \"" + attributeName + "\" does not exist!";
    }
}

QString Node::getAttributeType(QString attributeName) const
{
    if(m_attributes.contains(attributeName)){
        return m_attributes.value(attributeName)->getType();
    } else {
        qDebug() << "an attribute with the name \"" + attributeName + "\" does not exist!";
        throw "an attribute with the name \"" + attributeName + "\" does not exist!";
    }
}

QVariant Node::getAttributeValue(QString attributeName) const
{
    if(m_attributes.contains(attributeName)){
        return m_attributes.value(attributeName)->getValue();
    } else {
        qDebug() << "an attribute with the name \"" + attributeName + "\" does not exist!";
        throw "an attribute with the name \"" + attributeName + "\" does not exist!";
    }
}

void Node::setAttributeValue(QString attributeName, QVariant value)
{
    if(m_attributes.contains(attributeName)){
        NodeAttribute* attr = m_attributes.value(attributeName);

        if(attr->getValue() != value){
            attr->setValue(value);
            emit attributeValuesUpdated();
            cleanCache();
        }

    } else {
        qDebug() << "an attribute with the name \"" + attributeName + "\" does not exist!";
        throw "an attribute with the name \"" + attributeName + "\" does not exist!";
    }
}

QVariant Node::getAttributeDefaultValue(QString attributeName) const
{
    if(m_attributes.contains(attributeName)){
        return m_attributes.value(attributeName)->getDefaultValue();
    } else {
        qDebug() << "an attribute with the name \"" + attributeName + "\" does not exist!";
        throw "an attribute with the name \"" + attributeName + "\" does not exist!";
    }
}

bool Node::hasAttribute(QString attributeName) const
{
    return m_attributes.contains(attributeName);
}

QList<QString> Node::getAttributeNames() const
{
    return m_attributes.keys();
}

int Node::getInPortCount() const
{
    return m_inPortCount;
}

void Node::registerAttribute(QString key, NodeAttribute *attribute)
{
    m_attributes.insert(key, attribute);
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

GImage Node::getResultImage() {

    if(getInputNode()->inputType(this)){
        return m_img.deepCopy();
    }
    // no deep copy on failure
    return m_img;
}

GImage Node::resultImage()
{
    getInputNode()->inputType(this);

    return m_img;
}

const QVector<GImage> &Node::resultVideo()
{
    return m_vid;
}

GData Node::getResultData()
{
    if(getInputNode()->inputType(this)){
        return m_data.deepCopy();
    }
    // no deep copy on failure
    return m_data;
}

GData Node::resultData()
{
    getInputNode()->inputType(this);

    return m_data;
}

// Default behaviour
bool Node::inputType(Node* startNode)
{
    bool isCached = true;
    if(startNode->m_img.isEmpty() && startNode->m_data.isEmpty()){
        isCached = startNode->retrieveResult();
        emit startNode->cached(isCached);
    }
    return isCached;
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

QString Node::getNodeName() const {
    return m_nodeName;
}

QString Node::getWarningMessage() const
{
    return m_warningMessage;
}

// check if an edge to the toNode would create a circle
bool Node::hasGraphCircle(Node* toNode){

    if(toNode == this) {
        return true;
    }

    if(m_inNodes.size() == 0){

        return false;
    }

    return m_inNodes[0]->hasGraphCircle(toNode);
}

bool Node::isCyclicProcessing()
{
    return m_cyclicProcessing;
}

QString Node::getOutputType()
{
    return m_outputType;
}
