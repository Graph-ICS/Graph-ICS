#ifndef NODEPROVIDER_H
#define NODEPROVIDER_H

#include <QObject>
#include <QtQml>

class NodeProvider : public QObject
{
    Q_OBJECT
public:
    explicit NodeProvider(QObject* parent = nullptr);

    void registerNodes();

    Q_INVOKABLE QList<QString> getNodeNames() const;

private:
    QList<QString> m_nodeList;
};

#endif // NODEPROVIDER_H
