#ifndef ATTRIBUTEFACTORY_H
#define ATTRIBUTEFACTORY_H

#include <QVariant>

#include "attribute.h"

namespace G
{
class AttributeFactory
{
public:
    AttributeFactory();
    ~AttributeFactory();

    Attribute* makeIntTextField(int defaultValue, int minValue, int maxValue, int step, const QString& displayedName);
    Attribute* makeDoubleTextField(double defaultValue, double minValue, double maxValue, const QString& displayedName);
    Attribute* makePathTextField(const QString& defaultValue, const QList<QString>& acceptedFiles,
                                 const QString& fileType);
    Attribute* makeComboBox(const QString& defaultValue, const QList<QString>& acceptedStrings,
                            const QString& displayedName);
    Attribute* makeSwitchAttribute(bool defaultValue, const QString& displayedName);

private:
    Attribute m_textFieldPrototype;
};
} // namespace G

#endif // ATTRIBUTEFACTORY_H
