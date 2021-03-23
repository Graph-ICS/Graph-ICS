#include "nodecomboboxattribute.h"



NodeComboBoxAttribute::NodeComboBoxAttribute(QVariantList list) :
    NodeAttribute("ComboBox", list.at(0)),
    m_items(list)
{
    m_constraints.insert("size", QVariant(m_items.size()));
    for(int i = 0; i < m_items.size(); i++){
        m_constraints.insert(QString::number(i), m_items.at(i));
    }
}

void NodeComboBoxAttribute::setValue(QVariant value)
{
    m_value = value;
}
