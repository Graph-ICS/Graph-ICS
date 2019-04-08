#ifndef ITKBINARYMORPHCLOSINGFILTER_H
#define ITKBINARYMORPHCLOSINGFILTER_H

#include "node.h"

class ItkBinaryMorphClosingFilter : public Node
{
    Q_OBJECT
    Q_PROPERTY(double radius READ getRadius WRITE setRadius NOTIFY radiusChanged)

public:
    explicit ItkBinaryMorphClosingFilter();
    virtual ~ItkBinaryMorphClosingFilter() {}
    double getRadius() { return radius; }
    void setRadius(const double value);

    virtual bool retrieveResult();

signals:
    void radiusChanged();

private:
    double radius; //milimeters
};


#endif // ITKBINARYMORPHCLOSINGFILTER_H
