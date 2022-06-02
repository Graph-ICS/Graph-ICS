#ifndef NODE_H
#define NODE_H

#include <QDebug>
#include <QHash>
#include <QObject>
#include <QPixmap>
#include <QQmlListProperty>
#include <QVector>

#include "attribute.h"
#include "port.h"

#include "attributefactory.h"

namespace G
{
/*!
 * \brief Base class for all Graph-ICS nodes.
 * \details One of the fundamental concepts of Graph-ICS is that subclasses of Node deliver functionality by
 * implementing the pure virtual function retrieveResult. This can include many functions like Imagefilters, Video
 * exporting or displaying on a View. The nodes can be connected in a tree-like structure to build a series of
 * processing steps (e.g. a series of Imagefilters).
 */
class Node : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isLocked READ isLocked NOTIFY lockedChanged)
    Q_PROPERTY(bool isPartOfStream READ isPartOfStream NOTIFY partOfStreamChanged)

public:
    enum TYPE
    {
        INPUT,
        FILTER,
        OUTPUT
    };
    Q_ENUM(TYPE)

    enum STATUS
    {
        RETRIEVE_RESULT_FAILED,
        IN_PORT_CONNECTION_MISSING
    };
    Q_ENUM(STATUS)

    Node(const QString& name, TYPE type = FILTER);
    virtual ~Node();

    virtual bool retrieveResult() = 0;

    void registerPorts(const QVector<Port*>& inPorts, const QVector<Port*>& outPorts);
    void registerAttribute(const QString& name, Attribute* attribute);

    void registerCreationMessage(const QString& creationMessage);

    Q_INVOKABLE int getType() const;
    Q_INVOKABLE QString getName() const;
    Q_INVOKABLE QString getCreationMessage() const;

    Q_INVOKABLE void addInNode(G::Node* inNode, int outPortPosition, int inPortPosition);
    Q_INVOKABLE void removeInNode(G::Node* inNode, int inPortPosition);
    Q_INVOKABLE void addOutNode(G::Node* node);
    Q_INVOKABLE void removeOutNode(G::Node* node);

    Node* getInNode(int index) const;
    Node* getOutNode(int index) const;

    Q_INVOKABLE G::Node* getInputNode();

    Q_INVOKABLE int getInPortsCount();
    Q_INVOKABLE int getOutPortsCount();

    Q_INVOKABLE int getInPortType(int position) const;
    Q_INVOKABLE int getOutPortType(int position) const;

    Port* getInPort(int position) const;
    Port* getOutPort(int position) const;

    Q_INVOKABLE QList<QString> getAttributeNames() const;
    Q_INVOKABLE bool hasAttribute(const QString& name) const;
    Q_INVOKABLE G::Attribute* getAttribute(const QString& name) const;

    virtual void onAttributeValueChanged(Attribute* attribute);

    Q_INVOKABLE void clearCache();
    void clearStreamCache();

    bool isInPortConnectionMissing() const;
    Q_INVOKABLE bool hasGraphCircle(G::Node* toNode);

    void setStatus(STATUS status);

    void lock();
    void unlock();
    bool isLocked() const;

    bool isPartOfStream() const;

signals:
    void inNodeAdded(G::Node* inNode, int outPortPosition, int inPortPosition);
    void inNodeRemoved(G::Node* inNode, int inPortPosition);
    void attributeValueChanged(G::Attribute* attribute);
    void lockedChanged();
    void partOfStreamChanged();
    void message(QString message);
    void statusChanged(int messageCode);

protected:
    void setPartOfStream(bool value);

    static AttributeFactory attributeFactory;

private:
    const TYPE m_type;

    QString m_name;
    QString m_creationMessage;

    QVector<Port*> m_inPorts;
    QVector<Port*> m_outPorts;

    QMap<int, Node*> m_inNodes;
    QVector<Node*> m_outNodes;
    Node* m_firstInNode;

    QList<QPair<QString, QSharedPointer<Attribute>>> m_attributes;

    int m_lockCounter;
    int m_partOfStreamCounter;
};
} // namespace G

#endif // NODE_H
