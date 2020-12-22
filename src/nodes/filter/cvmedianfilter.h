#ifndef CVMEDIANFILTER_H
#define CVMEDIANFILTER_H

#include "node.h"
#include <qqml.h>

class CvMedianFilter : public Node
{
    Q_OBJECT

public:
    explicit CvMedianFilter();
    ~CvMedianFilter() {}

    virtual bool retrieveResult();
};

#endif // CVMEDIANFILTER_H
