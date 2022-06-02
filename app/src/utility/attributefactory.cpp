#include "attributefactory.h"

#include <QDebug>
#include <QUrl>

#include "doublevalidator.h"
#include "filepathvalidator.h"
#include "intvalidator.h"
#include "stringvalidator.h"

namespace G
{

AttributeFactory::AttributeFactory()
    : m_textFieldPrototype(
          Attribute::TEXTFIELD,
          {{"useIntValidator", false}, {"useDoubleValidator", false}, {"showFileButton", false}, {"fileType", ""}})
{
}

AttributeFactory::~AttributeFactory()
{
}

Attribute* AttributeFactory::makeIntTextField(int defaultValue, int minValue, int maxValue, int step,
                                              const QString& displayedName)
{
    Attribute* clone = m_textFieldPrototype.clone();
    clone->init(defaultValue, new IntValidator(minValue, maxValue, step), displayedName, {{"useIntValidator", true}});

    return clone;
}

Attribute* AttributeFactory::makeDoubleTextField(double defaultValue, double minValue, double maxValue,
                                                 const QString& displayedName)
{
    Attribute* clone = m_textFieldPrototype.clone();
    clone->init(defaultValue, new DoubleValidator(minValue, maxValue), displayedName, {{"useDoubleValidator", true}});

    return clone;
}

Attribute* AttributeFactory::makePathTextField(const QString& defaultValue, const QList<QString>& acceptedFiles,
                                               const QString& fileType)
{
    Attribute* clone = m_textFieldPrototype.clone();
    clone->init(defaultValue, new FilePathValidator(acceptedFiles), "",
                {{"showFileButton", true}, {"fileType", fileType}});

    return clone;
}

Attribute* AttributeFactory::makeComboBox(const QString& defaultValue, const QList<QString>& acceptedStrings,
                                          const QString& displayedName)
{
    Attribute* combo = new Attribute(Attribute::COMBOBOX, {{"acceptedStrings", QVariant(acceptedStrings)}});
    combo->init(defaultValue, new StringValidator(acceptedStrings), displayedName, {});

    return combo;
}

Attribute* AttributeFactory::makeSwitchAttribute(bool defaultValue, const QString& displayedName)
{
    Attribute* switchAttribute = new Attribute(Attribute::SWITCH, {});
    switchAttribute->init(defaultValue, new IntValidator(0, 1, 1), displayedName, {});
    return switchAttribute;
}

} // namespace G
