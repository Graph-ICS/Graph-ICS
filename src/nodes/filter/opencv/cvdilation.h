#ifndef CVDILATION_H
#define CVDILATION_H

#include <node.h>

class CvDilation : public Node
{
public:
    CvDilation();
    bool retrieveResult();

private:
    QVariantList m_list;
};

#endif // CVDILATION_H
