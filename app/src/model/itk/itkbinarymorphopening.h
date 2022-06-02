#ifndef ITKBINARYMORPHOPENING_H
#define ITKBINARYMORPHOPENING_H
#include "node.h"

namespace G
{
class ItkBinaryMorphOpening : public Node
{
    Q_OBJECT

public:
    explicit ItkBinaryMorphOpening();
    virtual ~ItkBinaryMorphOpening(){};

    virtual bool retrieveResult();

private:
    Port m_inPort;
    Port m_outPort;

    Attribute* m_radius;
};
} // namespace G
#endif // ITKBINARYMORPHOPENING_H
