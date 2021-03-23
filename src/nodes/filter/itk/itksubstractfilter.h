#ifndef ITKSUBSTRACTFILTER_H
#define ITKSUBSTRACTFILTER_H

#include "node.h"

class ItkSubstractFilter : public Node
{
    Q_OBJECT

public:
    explicit ItkSubstractFilter();
    virtual ~ItkSubstractFilter() {}

    virtual bool retrieveResult();

};


#endif // ITKSUBSTRACTFILTER_H
