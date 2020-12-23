#ifndef NODE_H
#define NODE_H

#include <QObject>
#include <QVector>
#include <QQmlListProperty>
#include <QPixmap>
#include <QHash>

#include "nodeattribute.h"
#include "nodeintattribute.h"
#include "nodepathattribute.h"
#include "nodedoubleattribute.h"
#include "nodeboolattribute.h"
#include "noderangeattribute.h"

#include "gimage.h"


class Node : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<Node> inNodes READ getInNodes)
    Q_PROPERTY(QQmlListProperty<Node> outNodes READ getInNodes)

public:
    explicit Node();
    virtual ~Node() {}


    QQmlListProperty<Node> getInNodes();
    QQmlListProperty<Node> getOutNodes();

    Q_INVOKABLE QString getInputNodeName();
    Node* getInputNode();

    Q_INVOKABLE void addInNode(Node* node);
    int getInNodeCount() const;
    Node* getInNode(int index) const;
    Q_INVOKABLE void removeInNode(Node* node);
    Q_INVOKABLE void clearInNodes();

    Q_INVOKABLE void addOutNode(Node* node);
    int getOutNodeCount() const;
    Node* getOutNode(int index) const;
    Q_INVOKABLE void removeOutNode(Node* node);
    Q_INVOKABLE void clearOutNodes();

    GImage getResult();
    virtual bool retrieveResult() = 0;

    Q_INVOKABLE QString getNodeName() const;
    Q_INVOKABLE QString getWarningMessage() const;

    Q_INVOKABLE void cleanCache();
    Q_INVOKABLE void cleanImageCache();
    Q_INVOKABLE void cleanVideoCache();

    Q_INVOKABLE QVariant getAttributeConstraint(QString attributeName, QString constraintName);
    Q_INVOKABLE QString getAttributeType(QString attributeName) const;
    Q_INVOKABLE QVariant getAttributeValue(QString attributeName) const;
    Q_INVOKABLE QVariant getAttributeDefaultValue(QString attributeName) const;
    Q_INVOKABLE bool hasAttribute(QString attributeName) const;

    // can be overwritten in the Children
    Q_INVOKABLE virtual void setAttributeValue(QString attributeName, QVariant value);

    Q_INVOKABLE QList<QString> getAttributeNames() const;

    Q_INVOKABLE int getInPortCount() const;

    const QVector<GImage>& getVideo();

    // Pruefung ob toNode bereits im Graphen ist, damit kein Zyklus entsteht
    Q_INVOKABLE bool hasGraphCircle(Node* toNode);

protected:
    GImage m_img;
    QVector<GImage> m_vid;

    int m_inPortCount;
    QVector<Node*> m_inNodes;
    QVector<Node*> m_outNodes;

    QString m_nodeName;
    QString m_warningMessage;

    QHash<QString, NodeAttribute*> m_attributes;

    void registerAttribute(QString key, NodeAttribute* attribute);

signals:
    void inNodesChanged();
    void outNodesChanged();
    void cached(bool value);
    void attributeValuesUpdated();

private:
    static void addInNode(QQmlListProperty<Node>*, Node*);
    static int getInNodeCount(QQmlListProperty<Node>*);
    static Node* getInNode(QQmlListProperty<Node>*, int);
    static void clearInNodes(QQmlListProperty<Node>*);

    static void addOutNode(QQmlListProperty<Node>*, Node*);
    static int getOutNodeCount(QQmlListProperty<Node>*);
    static Node* getOutNode(QQmlListProperty<Node>*, int);
    static void clearOutNodes(QQmlListProperty<Node>*);

    bool isCached;
};

#endif // NODE_H
