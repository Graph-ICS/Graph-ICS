#include "qtblackwhitefilter.h"
#include <QDebug>

QtBlackWhiteFilter::QtBlackWhiteFilter()
{
    m_nodeName  = "QtBlackWhite";
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
            if(!m_img.isSet()){
                return false;
            }

            QImage img = m_img.getQImage();

            for(int x = 0; x < img.width(); x++)
            {
                for(int y= 0; y < img.height(); y++) {
                    QRgb rgb = img.pixel(x, y);
                    int gray = qGray(rgb);
                    img.setPixel(x, y, qRgb(gray, gray, gray));
                }
            }

            m_img.setImage(img);

        } catch (int e) {
            qDebug() << "QtBlackWhiteFilter. Exception Nr. " << e << '\n';
            return false;
        }
    }
    return true;
}
