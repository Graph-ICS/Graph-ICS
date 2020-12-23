#ifndef NODEDOUBLEATTRIBUTE_H
#define NODEDOUBLEATTRIBUTE_H

#include "nodeattribute.h"

class NodeDoubleAttribute : public NodeAttribute
{
public:
    NodeDoubleAttribute(double defaultValue, double maxValue, double minValue = 0.0);

    void setValue(QVariant attributeValue);

private:
    const double m_minValue;
    const double m_maxValue;

};

#endif // NODEDOUBLEATTRIBUTE_H
