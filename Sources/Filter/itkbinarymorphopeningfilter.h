#ifndef ITKBINARYMORPHOPENINGFILTER_H
#define ITKBINARYMORPHOPENINGFILTER_H
#include "node.h"

class ItkBinaryMorphOpeningFilter : public Node
{
    Q_OBJECT
    Q_PROPERTY(double radius READ getRadius WRITE setRadius NOTIFY radiusChanged)

public:
    explicit ItkBinaryMorphOpeningFilter();
    virtual ~ItkBinaryMorphOpeningFilter() {}
    double getRadius();
    void setRadius(const double value);

    virtual bool retrieveResult();

signals:
    void radiusChanged();

private:
    double m_radius; //milimeters

};


#endif // ITKBINARYMORPHOPENINGFILTER_H
