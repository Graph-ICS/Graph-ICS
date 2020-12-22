#include "nodeprovider.h"
#include <QQmlProperty>

NodeProvider::NodeProvider(QObject *parent) :
    QObject(parent),
    m_list(QList<QString>())
{

}

QList<QString> NodeProvider::getNodeNames() const
{
    return m_list;
}
