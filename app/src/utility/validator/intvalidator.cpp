#include "intvalidator.h"

IntValidator::IntValidator(int minValue, int maxValue, int step)
    : m_max(maxValue)
    , m_min(minValue)
    , m_step(step)
{
    Q_ASSERT(m_max > m_min);
    Q_ASSERT(m_step > 0);
}

QVariant IntValidator::validate(const QVariant& value)
{
    bool ok;
    int intValue = value.toInt(&ok);

    if (!ok)
    {
        qDebug() << "IntValidator::validate: Value could not be converted to int!";
        return QVariant(m_min);
    }

    int validated;
    if (intValue > m_max)
    {
        validated = m_max;
    }
    else
    {
        for (validated = m_min; validated < intValue; validated += m_step)
        {
        }
    }

    return QVariant(validated);
}
