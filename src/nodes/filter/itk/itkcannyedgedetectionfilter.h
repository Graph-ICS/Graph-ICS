#ifndef ITKCANNYEDGEDETECTIONFILTER_H
#define ITKCANNYEDGEDETECTIONFILTER_H

#include "node.h"

class ItkCannyEdgeDetectionFilter : public Node
{
    Q_OBJECT

public:
    explicit ItkCannyEdgeDetectionFilter();
    virtual ~ItkCannyEdgeDetectionFilter() {}
    virtual bool retrieveResult();
};

#endif // ITKCANNYEDGEDETECTIONFILTER_H
