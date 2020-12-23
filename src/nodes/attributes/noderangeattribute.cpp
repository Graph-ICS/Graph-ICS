#include "noderangeattribute.h"


NodeRangeAttribute::NodeRangeAttribute(int maxValue, int minValue, int step) :
    NodeAttribute("Range", QVariant(minValue))
{
    m_constraints.insert("maxValue", QVariant(maxValue));
    m_constraints.insert("minValue", QVariant(minValue));
    m_constraints.insert("step", QVariant(step));
}

void NodeRangeAttribute::setValue(QVariant value)
{
    // hier muss nichts geprueft werden da die GUI das erledigt (Spinbox)
    m_value = value;
}
