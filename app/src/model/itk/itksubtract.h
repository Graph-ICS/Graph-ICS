#ifndef ITKSUBSTRACT_H
#define ITKSUBSTRACT_H

#include "node.h"

namespace G
{
class ItkSubtract : public Node
{
    Q_OBJECT

public:
    explicit ItkSubtract();
    virtual ~ItkSubtract()
    {
    }

    virtual bool retrieveResult();

private:
    Port m_imageOneInPort;
    Port m_imageTwoInPort;
    Port m_outPort;
};
} // namespace G

#endif // ITKSUBSTRACT_H
