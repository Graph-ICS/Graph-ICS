#ifndef ITKBINARYMORPHCLOSING_H
#define ITKBINARYMORPHCLOSING_H

#include "node.h"

namespace G
{
class ItkBinaryMorphClosing : public Node
{
    Q_OBJECT

public:
    explicit ItkBinaryMorphClosing();
    virtual ~ItkBinaryMorphClosing(){};

    virtual bool retrieveResult();

private:
    Port m_inPort;
    Port m_outPort;

    Attribute* m_radius;
};
} // namespace G

#endif // ITKBINARYMORPHCLOSING_H
