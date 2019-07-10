#ifndef NODE_H
#define NODE_H

#include <QObject>
#include <QVector>
#include <QQmlListProperty>
#include <QPixmap>


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

    Q_INVOKABLE void addInNode(Node* node);
    int getInNodeCount() const;
    Node* getInNode(int index) const;
    Q_INVOKABLE void removeInNode(Node* node);
    void clearInNodes();

    Q_INVOKABLE void addOutNode(Node* node);
    int getOutNodeCount() const;
    Node* getOutNode(int index) const;
    Q_INVOKABLE void removeOutNode(Node* node);
    void clearOutNodes();

    Q_INVOKABLE QPixmap getResult();
    virtual bool retrieveResult() = 0;

    void cleanCache();

protected:



    QPixmap m_img;

    QVector<Node*> m_inNodes;
    QVector<Node*> m_outNodes;

signals:
    void inNodesChanged();
    void outNodesChanged();

private:
    static void addInNode(QQmlListProperty<Node>*, Node*);
    static int getInNodeCount(QQmlListProperty<Node>*);
    static Node* getInNode(QQmlListProperty<Node>*, int);
    static void clearInNodes(QQmlListProperty<Node>*);

    static void addOutNode(QQmlListProperty<Node>*, Node*);
    static int getOutNodeCount(QQmlListProperty<Node>*);
    static Node* getOutNode(QQmlListProperty<Node>*, int);
    static void clearOutNodes(QQmlListProperty<Node>*);

};

#endif // NODE_H
