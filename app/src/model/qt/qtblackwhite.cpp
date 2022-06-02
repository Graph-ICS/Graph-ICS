#include "qtblackwhite.h"
#include <QDebug>

namespace G
{

QtBlackWhite::QtBlackWhite()
    : Node("QtBlackWhite")
    , m_inPort(Port::TYPE::GIMAGE)
    , m_outPort(Port::TYPE::GIMAGE)
{
    registerPorts({&m_inPort}, {&m_outPort});
}

bool QtBlackWhite::retrieveResult()
{
    try
    {
        QImage& img = m_inPort.getGImage()->getQImage();

        for (int x = 0; x < img.width(); x++)
        {
            for (int y = 0; y < img.height(); y++)
            {
                QRgb rgb = img.pixel(x, y);
                int gray = qGray(rgb);
                img.setPixel(x, y, qRgb(gray, gray, gray));
            }
        }

        m_outPort.getGImage()->setImage(img);
    }
    catch (int e)
    {
        qDebug() << "QtBlackWhite. Exception Nr. " << e << '\n';
        return false;
    }

    return true;
}
} // namespace G
