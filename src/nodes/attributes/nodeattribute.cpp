#include "nodeattribute.h"


NodeAttribute::NodeAttribute(QString type, QVariant defaultValue) :
    m_defaultValue(defaultValue),
    m_value(defaultValue),
    m_type(type)
{

}

QString NodeAttribute::getType() const
{
    return m_type;
}

const QVariant NodeAttribute::getDefaultValue()
{
    return m_defaultValue;
}

void NodeAttribute::setDefaultValue(QVariant value)
{
    m_defaultValue = value;
}

QVariant NodeAttribute::getValue() const
{
    return m_value;
}

QVariant NodeAttribute::getConstraint(QString key) const
{
    return m_constraints.contains(key) ? m_constraints.value(key) : throw "this constraint does not exist";
}

void NodeAttribute::setConstraintValue(QString key, QVariant value)
{
    QVariant copy = getConstraint(key);
    if(copy != value){
        m_constraints.remove(key);
        m_constraints.insert(key, value);
    }
}
