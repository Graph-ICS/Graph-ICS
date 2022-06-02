#ifndef CVDILATION_H
#define CVDILATION_H

#include <node.h>

namespace G
{
class CvDilation : public Node
{
public:
    CvDilation();
    bool retrieveResult();

private:
    Port m_inPort;
    Port m_outPort;

    QList<QString> m_elementList;
    Attribute* m_element;
    Attribute* m_kernelSize;
};
} // namespace G

#endif // CvDilation_H
