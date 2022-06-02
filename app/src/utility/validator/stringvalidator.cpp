#include "stringvalidator.h"

StringValidator::StringValidator(const QList<QString>& acceptedStrings)
    : m_acceptedStrings(acceptedStrings)
{
}

QVariant StringValidator::validate(const QVariant& value)
{
    if (m_acceptedStrings.isEmpty())
    {
        qDebug() << "StringValidator::validate: No accepted String specified!";
        return "";
    }
    QString sValue = value.toString();

    if (sValue.isEmpty())
    {
        qDebug() << "StringValidator::validate: Value could not be converted to QString!";
        return *m_acceptedStrings.begin();
    }

    for (QString& str : m_acceptedStrings)
    {
        if (sValue == str)
        {
            return str;
        }
    }

    return *m_acceptedStrings.begin();
}
