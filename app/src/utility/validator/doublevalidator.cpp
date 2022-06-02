#include "doublevalidator.h"

DoubleValidator::DoubleValidator(double minValue, double maxValue)
    : m_min(minValue)
    , m_max(maxValue)
{
    Q_ASSERT(m_min < m_max);
}

QVariant DoubleValidator::validate(const QVariant& value)
{
    bool ok;
    double dValue = value.toDouble(&ok);
    if (!ok)
    {
        qDebug() << "DoubleValidator::validate: Value could not be converted to double!";
        return m_min;
    }
    if (dValue < m_min)
    {
        return m_min;
    }
    if (dValue > m_max)
    {
        return m_max;
    }
    return dValue;
}
