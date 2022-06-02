#ifndef INTVALIDATOR_H
#define INTVALIDATOR_H

#include "validator.h"

class IntValidator : public Validator
{
public:
    IntValidator(int minValue, int maxValue, int step = 1);

    virtual QVariant validate(const QVariant& value);

private:
    int m_max;
    int m_min;
    int m_step;
};

#endif // INTVALIDATOR_H
