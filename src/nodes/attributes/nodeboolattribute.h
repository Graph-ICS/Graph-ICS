#ifndef NODEBOOLATTRIBUTE_H
#define NODEBOOLATTRIBUTE_H

#include "nodeattribute.h"

class NodeBoolAttribute : public NodeAttribute
{
public:
    NodeBoolAttribute(bool defaultValue);

    void setValue(QVariant value);
};

#endif // NODEBOOLATTRIBUTE_H
