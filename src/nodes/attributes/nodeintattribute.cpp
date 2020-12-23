#include "nodeintattribute.h"


NodeIntAttribute::NodeIntAttribute(int defaultValue, int maxValue, int minValue, int step) :
    NodeAttribute("Int", QVariant(defaultValue)),
    m_minValue(minValue),
    m_maxValue(maxValue),
    m_step(step)
{  
    if(m_maxValue < m_minValue) {
        throw "maxValue can not be smaller than minValue";
    }

    if(m_value.toInt() < m_minValue || m_value.toInt() > m_maxValue){
        throw "The specified attribute Value does not match the bounds";
    }
}

void NodeIntAttribute::setValue(QVariant attributeValue)
{
    int copy;

    if(attributeValue.toInt() > m_maxValue){
        copy = m_maxValue;
    } else {
        for(copy = m_minValue; copy < attributeValue.toInt(); copy += m_step){}
    }

    m_value = QVariant(copy);
}


