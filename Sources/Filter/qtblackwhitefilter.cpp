#include "qtblackwhitefilter.h"
#include <QDebug>

QtBlackWhiteFilter::QtBlackWhiteFilter()
{
}

bool QtBlackWhiteFilter::retrieveResult()
{
    //cleanCache();   //cache leeren weil, der kein Input hat
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
                    QRgb rgb = img.pixel(x, y);
                    int gray = qGray(rgb);
                    img.setPixel(x, y, qRgb(gray, gray, gray));
                }
            }
            m_img = QPixmap::fromImage(img);
        } catch (int e) {
            qDebug() << "QtBlackWhiteFilter. Exception Nr. " << e << '\n';
            return false;
        }
    }
    return true;
}
