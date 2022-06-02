#ifndef NODEATTRIBUTE_H
#define NODEATTRIBUTE_H

#include <QDebug>
#include <QString>
#include <QVariant>

#include "validator.h"

namespace G
{
class Attribute : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariant value READ getValue WRITE setValue NOTIFY valueChanged)
    Q_PROPERTY(bool isLocked READ isLocked NOTIFY lockedChanged)

public:
    enum CONTROL
    {
        TEXTFIELD,
        COMBOBOX,
        SWITCH
    };
    Q_ENUM(CONTROL);

    Attribute(CONTROL control, const QMap<QString, QVariant>& propertyMap);
    ~Attribute();

    void init(const QVariant& defaultValue, Validator* validator, const QString& displayedName,
              const QList<QPair<QString, QVariant>>& properties);

    Q_INVOKABLE int getControl() const;

    Q_INVOKABLE QString getDisplayedName() const;

    Q_INVOKABLE QVariant getProperty(const QString& property);
    Q_INVOKABLE void setProperty(const QString& property, const QVariant& value);

    Q_INVOKABLE QVariant getDefaultValue() const;

    QVariant getValue() const;
    void setValue(const QVariant& value);

    bool isLocked() const;
    void setLocked(bool value);

    void forceDisableLocking();

    Attribute* clone();

signals:
    void valueChanged();
    void lockedChanged();

private:
    CONTROL m_control;
    QString m_displayedName;
    QMap<QString, QVariant> m_propertyMap;

    QVariant m_value;
    QVariant m_defaultValue;
    QSharedPointer<Validator> m_validator;

    bool m_locked;
    bool m_lockingDisabled;
};
} // namespace G

#endif // NODEATTRIBUTE_H
