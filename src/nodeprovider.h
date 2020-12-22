#ifndef NODEPROVIDER_H
#define NODEPROVIDER_H

#include <QObject>
#include <QtQml>

class NodeProvider : public QObject
{
    Q_OBJECT
public:
    explicit NodeProvider(QObject *parent = nullptr);

    template<class T> void registerNode(QString nodeName);


    Q_INVOKABLE QList<QString> getNodeNames() const;

private:
    QList<QString> m_list;

};

template<class T>
void NodeProvider::registerNode(QString nodeName)
{
    QString import = "Model." + nodeName;
    QString nodeModel = nodeName + "_Model";

    qmlRegisterType<T>(import.toLocal8Bit().data(), 1, 0, nodeModel.toLocal8Bit().data());

    m_list.append(nodeName);
}

#endif // NODEPROVIDER_H
