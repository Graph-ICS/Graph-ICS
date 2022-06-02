#ifndef VALIDATOR_H
#define VALIDATOR_H

#include <QDebug>
#include <QVariant>

class Validator
{
public:
    Validator();
    virtual ~Validator();

    virtual QVariant validate(const QVariant& value) = 0;
};

#endif // VALIDATOR_H
