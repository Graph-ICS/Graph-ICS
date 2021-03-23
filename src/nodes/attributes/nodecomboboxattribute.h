#ifndef NODECOMBOBOXATTRIBUTE_H
#define NODECOMBOBOXATTRIBUTE_H

#include "nodeattribute.h"

class NodeComboBoxAttribute : public NodeAttribute
{
public:
    NodeComboBoxAttribute(QVariantList list);
    void setValue(QVariant value);

private:
    QVariantList m_items;
};

#endif // NODECOMBOBOXATTRIBUTE_H
