#ifndef STRINGVALIDATOR_H
#define STRINGVALIDATOR_H

#include "validator.h"

class StringValidator : public Validator
{
public:
    StringValidator(const QList<QString>& acceptedStrings);

    QVariant validate(const QVariant& value) override;

private:
    QList<QString> m_acceptedStrings;
};

#endif // STRINGVALIDATOR_H
