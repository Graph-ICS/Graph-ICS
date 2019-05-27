#include "qtlighterfilter.h"

#include <QDebug>

QtLighterFilter::QtLighterFilter()
{
    m_factor = 0.0;
}

void QtLighterFilter::setValue(const double value)
{
    if (value == m_factor)
        return;

    m_factor = value;
    cleanCache();
    emit valueChanged();
}

bool QtLighterFilter::retrieveResult(){

    if (m_inNodes.size() < 1) {
        return false;
    }
    else {
        try {
            m_img = m_inNodes[0]->getResult();
            QImage img = m_img.toImage();
            for(int x = 0; x < img.width(); x++)
            {
                for(int y= 0; y < img.height(); y++) {
                    QColor color = img.pixelColor(x, y);
                    color = color.lighter(m_factor);
                    img.setPixelColor(x, y, color);
                }
            }
            m_img = QPixmap::fromImage(img);

        } catch (int e) {
            qDebug() << "QtLighterFilter. Exception Nr. " << e << '\n';
            return false;
        }
    }
    return true;
}
