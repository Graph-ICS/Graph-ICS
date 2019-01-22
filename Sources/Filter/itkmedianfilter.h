#ifndef ITKMEDIANFILTER_H
#define ITKMEDIANFILTER_H

#include "node.h"
#include <itkRGBPixel.h>
#include <itkImage.h>

class ItkMedianFilter : public Node
{
    Q_OBJECT
    Q_PROPERTY(double radiusX READ getRadiusX WRITE setRadiusX NOTIFY radiusXChanged)
    Q_PROPERTY(double radiusY READ getRadiusY WRITE setRadiusY NOTIFY radiusYChanged)

public:
    explicit ItkMedianFilter();

    double getRadiusX() { return m_radiusX; }
    double getRadiusY() { return m_radiusY; }
    void setRadiusX(const double value);
    void setRadiusY(const double value);

    bool retrieveResult();

signals:
    void radiusXChanged();
    void radiusYChanged();

private:
    double m_radiusX;
    double m_radiusY;
};


#endif // ITKMEDIANFILTER_H
