#ifndef FILEPATHVALIDATOR_H
#define FILEPATHVALIDATOR_H

#include "validator.h"

class FilePathValidator : public Validator
{
public:
    FilePathValidator(QList<QString> acceptedFiles);

    QVariant validate(const QVariant& value) override;

private:
    QList<QString> m_acceptedFiles;
};

#endif // FILEPATHVALIDATOR_H
