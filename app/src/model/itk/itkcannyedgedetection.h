#ifndef ITKCANNYEDGEDETECTION_H
#define ITKCANNYEDGEDETECTION_H

#include "node.h"

namespace G
{
class ItkCannyEdgeDetection : public Node
{
    Q_OBJECT

public:
    ItkCannyEdgeDetection();
    virtual bool retrieveResult() override;

private:
    Port m_inPort;
    Port m_outPort;

    Attribute* m_variance;
    Attribute* m_upperThreshold;
    Attribute* m_lowerThreshold;
};
} // namespace G

#endif // ITKCANNYEDGEDETECTION_H
