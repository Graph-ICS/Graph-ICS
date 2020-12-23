#ifndef FILTERATTRIBUTE_H
#define FILTERATTRIBUTE_H

#include <iostream>
#include "nodeattribute.h"

class NodeIntAttribute : public NodeAttribute {

public:
    NodeIntAttribute(int defaultValue, int maxValue, int minValue = 0, int step = 1);

    void setValue(QVariant attributeValue);

private:
    // min and max Value are the bounds for the attributeValue
    const int m_minValue;
    const int m_maxValue;

    // step is the next allowed attributeValue (e.g. step = 1.0 -> allowed values 0, 1, 2, 3, ... )
    const int m_step;


};

#endif // FILTERATTRIBUTE_H
