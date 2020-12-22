#ifndef ITKBINARYMORPHOPENINGFILTER_H
#define ITKBINARYMORPHOPENINGFILTER_H
#include "node.h"

class ItkBinaryMorphOpeningFilter : public Node
{
    Q_OBJECT

public:
    explicit ItkBinaryMorphOpeningFilter();
    virtual ~ItkBinaryMorphOpeningFilter() {}

    virtual bool retrieveResult();
};


#endif // ITKBINARYMORPHOPENINGFILTER_H
