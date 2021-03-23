#if !defined(VIEW_H)
#define VIEW_H

#include "node.h"
#include <QObject>
#include <QVariant>

class View : public QObject
{
    Q_OBJECT

public:
    View(QObject *parent = nullptr);
    Q_INVOKABLE void connectNode(Node* node);
    Q_INVOKABLE void removeConnection();
    Q_INVOKABLE bool hasConnection();

    Node* getConnectedNode();

signals:
    void updateView(const QVariant& result);
    void stopTask();
    void printMessageForNode(const QString& message);

private:
    Node *m_connectedNode;
    bool m_hasConnection;
};

#endif // VIEW_H



