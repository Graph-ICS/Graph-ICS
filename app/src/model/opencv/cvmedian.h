#ifndef CVMEDIAN_H
#define CVMEDIAN_H

#include "node.h"
#include <qqml.h>

namespace G
{
class CvMedian : public Node
{
    Q_OBJECT

public:
    explicit CvMedian();
    ~CvMedian()
    {
    }

    virtual bool retrieveResult();

private:
    Port m_inPort;
    Port m_outPort;

    Attribute* m_kernelSize;
};
} // namespace G
#endif // CVMEDIAN_H
