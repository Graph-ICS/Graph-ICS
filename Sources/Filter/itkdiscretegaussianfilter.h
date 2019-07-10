#ifndef ITKDISCRETEGAUSSIANFILTER_H
#define ITKDISCRETEGAUSSIANFILTER_H

#include "node.h"

class ItkDiscreteGaussianFilter : public Node
{
    Q_OBJECT
    Q_PROPERTY(double variance READ getVariance WRITE setVariance NOTIFY varianceChanged)

public:
    explicit ItkDiscreteGaussianFilter();
    virtual ~ItkDiscreteGaussianFilter() {}
    double getVariance();
    void setVariance(const double value);

    virtual bool retrieveResult();

signals:
    void varianceChanged();

private:
    double m_variance; //milimeters

};


#endif // ITKDISCRETEGAUSSIANFILTER_H
