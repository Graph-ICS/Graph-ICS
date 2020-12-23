#ifndef NODERANGEATTRIBUTE_H
#define NODERANGEATTRIBUTE_H

#include "nodeattribute.h"

class NodeRangeAttribute : public NodeAttribute
{
public:
    NodeRangeAttribute(int maxValue, int minValue = 0, int step = 1);

    void setValue(QVariant value);

};

#endif // NODERANGEATTRIBUTE_H
