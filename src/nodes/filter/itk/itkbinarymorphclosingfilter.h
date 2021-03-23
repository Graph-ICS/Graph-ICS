#ifndef ITKBINARYMORPHCLOSINGFILTER_H
#define ITKBINARYMORPHCLOSINGFILTER_H

#include "node.h"

class ItkBinaryMorphClosingFilter : public Node
{
    Q_OBJECT

public:
    explicit ItkBinaryMorphClosingFilter();
    virtual ~ItkBinaryMorphClosingFilter() {}

    virtual bool retrieveResult();

};


#endif // ITKBINARYMORPHCLOSINGFILTER_H
