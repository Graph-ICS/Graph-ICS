#ifndef CVHISTOGRAMCALCULATION_H
#define CVHISTOGRAMCALCULATION_H

#include <node.h>

namespace G
{
class CvHistogramCalculation : public Node
{
public:
    CvHistogramCalculation();
    bool retrieveResult();

private:
    Port m_inPort;
    Port m_dataOutPort;
    Port m_imageOutPort;

    PointSet createPointSet(const QString& label, const QColor& color, const cv::Mat& mat);
};
} // namespace G

#endif // CvHistogramCalculation_H
