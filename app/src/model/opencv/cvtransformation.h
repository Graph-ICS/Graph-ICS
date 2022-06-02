#ifndef CVTRANSFORMATION_H
#define CVTRANSFORMATION_H

#include <node.h>

namespace G
{
class CvTransformation : public Node
{
public:
    CvTransformation();

    bool retrieveResult();

private:
    Port m_inPort;
    Port m_outPort;

    Attribute* m_angle;
    Attribute* m_scale;
};
} // namespace G

#endif // CvTransformation_H
