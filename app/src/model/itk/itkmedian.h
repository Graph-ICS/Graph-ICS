#ifndef ITKMEDIAN_H
#define ITKMEDIAN_H

#include "node.h"

namespace G
{
class ItkMedian : public Node
{
    Q_OBJECT

public:
    explicit ItkMedian();
    virtual ~ItkMedian()
    {
    }

    virtual bool retrieveResult();

private:
    Port m_inPort;
    Port m_outPort;

    Attribute* m_radiusX;
    Attribute* m_radiusY;
};
} // namespace G

#endif // ITKMEDIAN_H
