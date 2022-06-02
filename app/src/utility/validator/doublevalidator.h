#ifndef DOUBLEVALIDATOR_H
#define DOUBLEVALIDATOR_H

#include "validator.h"

class DoubleValidator : public Validator
{
public:
    DoubleValidator(double minValue, double maxValue);

    QVariant validate(const QVariant& value) override;

private:
    double m_min;
    double m_max;
};

#endif // DOUBLEVALIDATOR_H
