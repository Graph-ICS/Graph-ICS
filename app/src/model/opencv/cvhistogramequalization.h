#ifndef CVHISTOGRAMEQUALIZATION_H
#define CVHISTOGRAMEQUALIZATION_H

#include "node.h"

namespace G
{
class CvHistogramEqualization : public Node
{
    Q_OBJECT

public:
    CvHistogramEqualization();

    bool retrieveResult();

private:
    Port m_inPort;
    Port m_outPort;
};
} // namespace G

#endif // CvHistogramEqualization_H
