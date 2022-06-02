#include "attribute.h"

namespace G
{

Attribute::Attribute(CONTROL control, const QMap<QString, QVariant>& propertyMap)
    : m_control(control)
    , m_propertyMap(propertyMap)
    , m_value(0)
    , m_defaultValue(0)
    , m_validator(nullptr)
    , m_locked(false)
    , m_lockingDisabled(false)
{
}

Attribute::~Attribute()
{
}

void Attribute::init(const QVariant& defaultValue, Validator* validator, const QString& displayedName,
                     const QList<QPair<QString, QVariant>>& properties)
{
    Q_ASSERT(validator->validate(defaultValue) == defaultValue);

    m_value = defaultValue;
    m_defaultValue = defaultValue;
    m_validator.reset(validator);

    m_displayedName = displayedName;
    for (const QPair<QString, QVariant>& pair : properties)
    {
        setProperty(pair.first, pair.second);
    }
}

int Attribute::getControl() const
{
    return m_control;
}

QString Attribute::getDisplayedName() const
{
    return m_displayedName;
}

QVariant Attribute::getProperty(const QString& property)
{
    Q_ASSERT(m_propertyMap.contains(property));
    return m_propertyMap[property];
}

void Attribute::setProperty(const QString& property, const QVariant& value)
{
    Q_ASSERT(m_propertyMap.contains(property));
    m_propertyMap[property] = value;
}

QVariant Attribute::getDefaultValue() const
{
    return m_defaultValue;
}

QVariant Attribute::getValue() const
{
    return m_value;
}

void Attribute::setValue(const QVariant& value)
{
    if (m_value != value)
    {
        if (m_validator == nullptr)
        {
            m_value = value;
        }
        else
        {
            m_value = m_validator->validate(value);
        }
        emit valueChanged();
    }
}

bool Attribute::isLocked() const
{
    return m_locked;
}

void Attribute::setLocked(bool value)
{
    if (m_lockingDisabled)
    {
        return;
    }

    if (m_locked != value)
    {
        m_locked = value;
        emit lockedChanged();
    }
}

void Attribute::forceDisableLocking()
{
    m_lockingDisabled = true;
}

Attribute* Attribute::clone()
{
    Attribute* clone = new Attribute(m_control, m_propertyMap);

    clone->m_value = m_value;
    clone->m_defaultValue = m_defaultValue;
    clone->m_validator = m_validator;

    return clone;
}

} // namespace G
