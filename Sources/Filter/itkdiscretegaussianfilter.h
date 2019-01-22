#ifndef ITKDISCRETEGAUSSIANFILTER_H
#define ITKDISCRETEGAUSSIANFILTER_H

#include "node.h"

class ItkDiscreteGaussianFilter : public Node
{
    Q_OBJECT
    Q_PROPERTY(double variance READ getVariance WRITE setVariance NOTIFY varianceChanged)

public:
    explicit ItkDiscreteGaussianFilter();
    double getVariance() { return variance; }
    void setVariance(const double value);

    bool retrieveResult();

signals:
    void varianceChanged();

private:
    double variance; //milimeters

};


#endif // ITKDISCRETEGAUSSIANFILTER_H
