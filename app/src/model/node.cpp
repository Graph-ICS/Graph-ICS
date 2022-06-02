#include "node.h"

#include "cutframescommand.h"
#include "pasteframescommand.h"

#include "qqml.h"

#include <QDebug>

namespace G
{

AttributeFactory Node::attributeFactory;

Node::Node(const QString& name, TYPE type)
    : m_type(type)
    , m_name(name)
    , m_inPorts()
    , m_outPorts()
    , m_inNodes()
    , m_outNodes()
    , m_firstInNode(nullptr)
    , m_attributes()
    , m_lockCounter(0)
    , m_partOfStreamCounter(0)
{
    QObject::connect(this, &Node::lockedChanged, this, [this] {
        for (auto& pair : m_attributes)
        {
            pair.second->setLocked(isLocked());
        }
    });
    QObject::connect(this, &Node::attributeValueChanged, this, &Node::onAttributeValueChanged);
}

Node::~Node()
{
}

void Node::registerPorts(const QVector<Port*>& inPorts, const QVector<Port*>& outPorts)
{
    if (m_type == OUTPUT)
    {
        // Output Nodes only support 1 inPort
        // maybe change in the future
        // (Many inPorts assemble to one result into one outPort)?
        Q_ASSERT(outPorts.size() == 0 && inPorts.size() == 1);
    }
    if (m_type == INPUT)
    {
        Q_ASSERT(inPorts.size() == 0);
    }
    if (m_type == FILTER)
    {
        Q_ASSERT(inPorts.size() > 0 && outPorts.size() > 0);
    }

    m_inPorts = inPorts;
    for (Port*& port : m_inPorts)
    {
        port->setCacheingAllowed(false);
    }

    m_outPorts = outPorts;
}

void Node::registerAttribute(const QString& name, Attribute* attribute)
{
    Q_ASSERT(!hasAttribute(name));
    m_attributes.append(QPair<QString, QSharedPointer<Attribute>>(name, QSharedPointer<Attribute>(attribute)));
    QObject::connect(attribute, &Attribute::valueChanged, this, [this] {
        Attribute* attribute = qobject_cast<Attribute*>(sender());
        Q_ASSERT(attribute != nullptr);
        emit attributeValueChanged(attribute);
    });
}

void Node::registerCreationMessage(const QString& creationMessage)
{
    m_creationMessage = creationMessage;
}

int Node::getType() const
{
    return m_type;
}

QString Node::getName() const
{
    return m_name;
}

QString Node::getCreationMessage() const
{
    return m_creationMessage;
}

void Node::addInNode(Node* inNode, int outPortPosition, int inPortPosition)
{
    bool empty = m_inNodes.isEmpty();

    m_inNodes.insert(inPortPosition, inNode);

    m_inPorts[inPortPosition]->connectPort(inNode->m_outPorts[outPortPosition]);

    if (empty)
    {
        m_firstInNode = inNode;
    }

    clearStreamCache();

    emit inNodeAdded(inNode, outPortPosition, inPortPosition);
}

void Node::removeInNode(Node* inNode, int inPortPosition)
{
    if (isLocked())
    {
        qDebug() << m_name + "::removeInNode: Cannot remove connection from a locked Node!";
        return;
    }

    m_inNodes.remove(inPortPosition);
    m_inPorts[inPortPosition]->disconnectPort();

    if (inNode == m_firstInNode)
    {
        if (m_inNodes.isEmpty())
        {
            m_firstInNode = nullptr;
        }
        else
        {
            m_firstInNode = m_inNodes.first();
        }
    }

    clearStreamCache();

    emit inNodeRemoved(inNode, inPortPosition);
}

void Node::addOutNode(Node* node)
{
    if (node->m_type == OUTPUT)
    {
        setPartOfStream(true);
    }
    m_outNodes.append(node);
}

void Node::removeOutNode(Node* node)
{
    if (node->m_type == OUTPUT)
    {
        setPartOfStream(false);
    }
    m_outNodes.removeOne(node);
}

Node* Node::getInNode(int index) const
{
    return m_inNodes.value(index, nullptr);
}

Node* Node::getOutNode(int index) const
{
    return m_outNodes.at(index);
}

Node* Node::getInputNode()
{
    if (m_firstInNode != nullptr)
    {
        return m_firstInNode->getInputNode();
    }
    return this;
}

int Node::getInPortsCount()
{
    return m_inPorts.size();
}

int Node::getOutPortsCount()
{
    return m_outPorts.size();
}

int Node::getInPortType(int position) const
{
    return m_inPorts.at(position)->getType();
}

int Node::getOutPortType(int position) const
{
    return m_outPorts.at(position)->getType();
}

Port* Node::getInPort(int position) const
{
    return m_inPorts[position];
}

Port* Node::getOutPort(int position) const
{
    return m_outPorts[position];
}

QList<QString> Node::getAttributeNames() const
{
    QList<QString> nameList;
    for (auto& pair : m_attributes)
    {
        nameList.append(pair.first);
    }
    return nameList;
}

bool Node::hasAttribute(const QString& name) const
{
    for (auto& pair : m_attributes)
    {
        if (pair.first == name)
        {
            return true;
        }
    }
    return false;
}

Attribute* Node::getAttribute(const QString& name) const
{
    for (auto& pair : m_attributes)
    {
        if (pair.first == name)
        {
            return pair.second.data();
        }
    }
    Q_ASSERT(false);
    return nullptr;
}

void Node::onAttributeValueChanged(Attribute* /*attribute*/)
{
    clearStreamCache();
}

void Node::clearCache()
{
    QVector<Port*> ports(m_inPorts);
    ports += m_outPorts;
    for (Port*& port : ports)
    {
        port->clearCache();
    }
}

void Node::clearStreamCache()
{
    for (Node*& node : m_outNodes)
    {
        node->clearStreamCache();
    }

    clearCache();
}

bool Node::isInPortConnectionMissing() const
{
    for (Port* port : m_inPorts)
    {
        if (!port->hasConnectedPort() && port->isRequired())
        {
            return true;
        }
    }
    return false;
}

bool Node::hasGraphCircle(Node* toNode)
{
    if (toNode == this)
    {
        return true;
    }

    for (Node*& node : m_inNodes)
    {
        if (node != nullptr)
        {
            if (node->hasGraphCircle(toNode))
            {
                return true;
            }
        }
    }

    return false;
}

void Node::setStatus(STATUS status)
{
    emit statusChanged(status);
}

void Node::lock()
{
    m_lockCounter++;
    if (m_lockCounter == 1)
    {
        emit lockedChanged();
    }
    for (Node*& node : m_inNodes)
    {
        if (node != nullptr)
        {
            node->lock();
        }
    }
}

void Node::unlock()
{
    Q_ASSERT(m_lockCounter != 0);
    m_lockCounter--;
    if (m_lockCounter == 0)
    {
        emit lockedChanged();
    }
    for (Node*& node : m_inNodes)
    {
        if (node != nullptr)
        {
            node->unlock();
        }
    }
}

bool Node::isLocked() const
{
    return m_lockCounter > 0;
}

bool Node::isPartOfStream() const
{
    return m_partOfStreamCounter > 0;
}

void Node::setPartOfStream(bool value)
{
    if (value)
    {
        m_partOfStreamCounter++;
    }
    else
    {
        m_partOfStreamCounter--;
    }

    if (m_partOfStreamCounter == 0 || m_partOfStreamCounter == 1)
    {
        emit partOfStreamChanged();
    }

    for (Node*& node : m_inNodes)
    {
        if (node != nullptr)
        {
            node->setPartOfStream(value);
        }
    }
}

} // namespace G
