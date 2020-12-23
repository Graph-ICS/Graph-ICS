#ifndef ITKMEDIANFILTER_H
#define ITKMEDIANFILTER_H

#include "node.h"

class ItkMedianFilter : public Node
{
    Q_OBJECT

public:
    explicit ItkMedianFilter();
    virtual ~ItkMedianFilter() {}

    virtual bool retrieveResult();
};


#endif // ITKMEDIANFILTER_H
