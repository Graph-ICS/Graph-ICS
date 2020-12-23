#include "nodeboolattribute.h"

NodeBoolAttribute::NodeBoolAttribute(bool defaultValue) :
    NodeAttribute("Bool", QVariant(defaultValue))
{

}

void NodeBoolAttribute::setValue(QVariant value)
{
    m_value = value.toBool();
}


