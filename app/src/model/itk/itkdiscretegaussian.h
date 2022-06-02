#ifndef ITKDISCRETEGAUSSIAN_H
#define ITKDISCRETEGAUSSIAN_H

#include "node.h"

namespace G
{
class ItkDiscreteGaussian : public Node
{
    Q_OBJECT

public:
    explicit ItkDiscreteGaussian();
    virtual ~ItkDiscreteGaussian(){};

    virtual bool retrieveResult();

private:
    Port m_inPort;
    Port m_outPort;

    Attribute* m_variance;
};
} // namespace G

#endif // ITKDISCRETEGAUSSIAN_H
