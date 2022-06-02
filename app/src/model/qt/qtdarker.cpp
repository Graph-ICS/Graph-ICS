#include "qtdarker.h"
#include <QDebug>

namespace G
{

QtDarker::QtDarker()
    : Node("QtDarker")
    , m_inPort(Port::TYPE::GIMAGE)
    , m_outPort(Port::TYPE::GIMAGE)
    , m_factor(attributeFactory.makeIntTextField(200, 0, 1000, 1, "Factor"))
{
    registerPorts({&m_inPort}, {&m_outPort});
    registerAttribute("factor", m_factor);
}

bool QtDarker::retrieveResult()
{
    try
    {
        QImage& img = m_inPort.getGImage()->getQImage();

        for (int x = 0; x < img.width(); x++)
        {
            for (int y = 0; y < img.height(); y++)
            {
                QColor color = img.pixelColor(x, y);
                color = color.darker(m_factor->getValue().toInt());
                img.setPixelColor(x, y, color);
            }
        }

        m_outPort.getGImage()->setImage(img);
    }
    catch (int e)
    {
        qDebug() << "QtDarker Exception Nr. " << e << '\n';
        return false;
    }

    return true;
}
} // namespace G
