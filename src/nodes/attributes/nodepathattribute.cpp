#include "nodepathattribute.h"


NodePathAttribute::NodePathAttribute(QString nameFilter, QString path) :
    NodeAttribute("Path", QVariant(path))
{
    m_constraints.insert("nameFilter", nameFilter);
}

void NodePathAttribute::setValue(QVariant value)
{
    QString val = value.toString();
    if(val.startsWith("file:")){
        val.remove(0, PATHOVERHEAD);
    }

    if(m_value.toString() != val){
        m_value = QVariant(val);
    }
}
