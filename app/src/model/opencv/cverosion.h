#ifndef CVEROSION_H
#define CVEROSION_H

#include <node.h>

namespace G
{
class CvErosion : public Node
{
public:
    CvErosion();
    bool retrieveResult();

private:
    Port m_inPort;
    Port m_outPort;

    QList<QString> m_elementList;
    Attribute* m_element;
    Attribute* m_kernelSize;
};
} // namespace G

#endif // CvErosion_H
