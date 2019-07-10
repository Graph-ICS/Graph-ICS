#ifndef ITKCANNYEDGEDETECTIONFILTER_H
#define ITKCANNYEDGEDETECTIONFILTER_H

#include "node.h"

class ItkCannyEdgeDetectionFilter : public Node
{
    Q_OBJECT
    Q_PROPERTY(double variance READ getVariance WRITE setVariance NOTIFY varianceChanged)
    Q_PROPERTY(double upperThreshold READ getUpperThreshold WRITE setUpperThreshold NOTIFY upperThresholdChanged)
    Q_PROPERTY(double lowerThreshold READ getLowerThreshold WRITE setLowerThreshold NOTIFY lowerThresholdChanged)

public:
    explicit ItkCannyEdgeDetectionFilter();
    virtual ~ItkCannyEdgeDetectionFilter() {}
    double getVariance();
    void setVariance(const double value);

    double getUpperThreshold() const;
    void setUpperThreshold(double value);

    double getLowerThreshold() const;
    void setLowerThreshold(double value);

    virtual bool retrieveResult();

signals:
    void varianceChanged();
    void upperThresholdChanged();
    void lowerThresholdChanged();

private:
    //variance: adjusts the
    //amount of Gaussian smoothing
    double m_variance;
    //upper/lowerThreshold: control which edges
    //are selected in the final step.
    double m_upperThreshold;
    double m_lowerThreshold;
};

#endif // ITKCANNYEDGEDETECTIONFILTER_H
