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
#include "nodecomboboxattribute.h"

#include "gimage.h"
#include "gdata.h"


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

    // called in every filternode to get the result of the inNode
    // returns a deepCopy of the result
    GImage getResultImage();
    // get the result without a deepCopy
    GImage resultImage();
    const QVector<GImage>& resultVideo();

    GData getResultData();
    GData resultData();

    // if special behavior for the input node is needed then the nodes override this function
    // e.g. Video // TODO: make private
    virtual bool inputType(Node* node);

    // gets implemented in every concrete Node
    virtual bool retrieveResult() = 0;

    Q_INVOKABLE QString getNodeName() const;
    Q_INVOKABLE QString getWarningMessage() const;

    Q_INVOKABLE void cleanCache();

    // Attribute stuff
    Q_INVOKABLE QVariant getAttributeConstraint(QString attributeName, QString constraintName);
    Q_INVOKABLE QString getAttributeType(QString attributeName) const;
    Q_INVOKABLE QVariant getAttributeValue(QString attributeName) const;
    Q_INVOKABLE QVariant getAttributeDefaultValue(QString attributeName) const;
    Q_INVOKABLE bool hasAttribute(QString attributeName) const;

    // can be overwritten in the derived classes for special behaviour
    Q_INVOKABLE virtual void setAttributeValue(QString attributeName, QVariant value);

    Q_INVOKABLE QList<QString> getAttributeNames() const;

    Q_INVOKABLE int getInPortCount() const;

    // Pruefung ob toNode bereits im Graphen ist, damit kein Zyklus entsteht
    Q_INVOKABLE bool hasGraphCircle(Node* toNode);

    bool isCyclicProcessing();
    Q_INVOKABLE QString getOutputType();

    // friend to access the protected variables of another derived node class
    friend class Video;

protected:

    // ************************************
    // define behaviour of a node
    // you can set these in the constructor of your node
    int m_inPortCount; // the amount of in ports the node has
    QString m_nodeName; // *! must be set!* the class name of the concrete node
    QString m_warningMessage; // message that is displayed, when the node is created
    bool m_cyclicProcessing; // define wether your node is processed in a loop or not
    QString m_outputType; // "GImage", "GData"
    void registerAttribute(QString key, NodeAttribute* attribute); // register the attribute of the node
    // these variables have a default value set in the constructor of "Node"
    // ************************************

    // data types that can be processed by a node
    GImage m_img;
    QVector<GImage> m_vid;
    GData m_data;
    QVector<GData> m_matrix;

    QMap<QString, NodeAttribute*> m_attributes;
    QVector<Node*> m_inNodes;
    QVector<Node*> m_outNodes;
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
