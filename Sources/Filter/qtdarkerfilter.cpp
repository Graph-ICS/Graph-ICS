#include "qtdarkerfilter.h"
#include <QDebug>

QtDarkerFilter::QtDarkerFilter()
{
    m_factor = 0.0;
}

double QtDarkerFilter::getFactor()
{
    return m_factor;
}

void QtDarkerFilter::setFactor(const double value)
{

    if (value == m_factor)
        return;

    m_factor = value;
    cleanCache();
    emit factorChanged();
}

bool QtDarkerFilter::retrieveResult()
{
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
                    color = color.darker(m_factor);
                    img.setPixelColor(x, y, color);
                }
            }
            m_img = QPixmap::fromImage(img);

        } catch (int e) {
            qDebug() << "QtDarkerFilter. Exception Nr. " << e << '\n';
            return false;
        }
    }
    return true;
}

