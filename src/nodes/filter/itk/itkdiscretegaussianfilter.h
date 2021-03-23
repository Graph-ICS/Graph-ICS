#ifndef ITKDISCRETEGAUSSIANFILTER_H
#define ITKDISCRETEGAUSSIANFILTER_H

#include "node.h"

class ItkDiscreteGaussianFilter : public Node
{
    Q_OBJECT

public:
    explicit ItkDiscreteGaussianFilter();
    virtual ~ItkDiscreteGaussianFilter() {}

    virtual bool retrieveResult();
};


#endif // ITKDISCRETEGAUSSIANFILTER_H
