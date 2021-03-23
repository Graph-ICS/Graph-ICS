#ifndef CVEROSION_H
#define CVEROSION_H

#include <node.h>

class CvErosion : public Node
{
public:
    CvErosion();
    bool retrieveResult();
private:
    QVariantList m_elementList;

};

#endif // CVEROSION_H
