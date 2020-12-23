#ifndef NODEATTRIBUTE_H
#define NODEATTRIBUTE_H

#include <QString>
#include <QVariant>
#include <QHash>
#include <QDebug>

//Base Class for all NodeAttributes
class NodeAttribute
{
public:
    NodeAttribute(QString type, QVariant defaultValue);

    QString getType() const;

    const QVariant getDefaultValue();
    void setDefaultValue(QVariant value);

    QVariant getValue() const;
    virtual void setValue(QVariant value) = 0;

    QVariant getConstraint(QString key) const;
    void setConstraintValue(QString key, QVariant value);

protected:
    QVariant m_defaultValue;
    QVariant m_value;
    QHash<QString, QVariant> m_constraints;

private:
    // AttributeType ( Int, Path, Double, ... )
    // starts with Uppercase Letter, gets set in the Constructor of every concrete NodeAttribute
    const QString m_type;

};

#endif // NODEATTRIBUTE_H
