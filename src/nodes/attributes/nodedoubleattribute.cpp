#include "nodedoubleattribute.h"


NodeDoubleAttribute::NodeDoubleAttribute(double defaultValue, double maxValue, double minValue) :
    NodeAttribute("Double", QVariant(defaultValue)),
    m_minValue(minValue),
    m_maxValue(maxValue)
{
    if(m_maxValue < m_minValue) {
        throw "maxValue can not be smaller than minValue";
    }

    if(m_value.toDouble() < m_minValue || m_value.toDouble() > m_maxValue){
        throw "The specified attribute Value does not match the bounds";
    }
}

void NodeDoubleAttribute::setValue(QVariant attributeValue)
{
    double copy = attributeValue.toDouble();

    if(attributeValue.toDouble() > m_maxValue){
        copy = m_maxValue;
    }
    if(attributeValue.toDouble() < m_minValue){
        copy = m_minValue;
    }

    m_value = QVariant(copy);
}
