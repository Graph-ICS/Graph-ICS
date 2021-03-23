#include "qtdarkerfilter.h"
#include <QDebug>

QtDarkerFilter::QtDarkerFilter()
{
    registerAttribute("factor",  new NodeIntAttribute(200, 1000));
    m_nodeName = "QtDarker";
}

bool QtDarkerFilter::retrieveResult()
{
    if (m_inNodes.size() < 1) {
        return false;
    }
    else {
        try {
            m_img = m_inNodes[0]->getResultImage();
            if(m_img.isEmpty()){
                return false;
            }

            QImage img = m_img.getQImage();

            for(int x = 0; x < img.width(); x++)
            {
                for(int y= 0; y < img.height(); y++) {
                    QColor color = img.pixelColor(x, y);
                    color = color.darker(getAttributeValue("factor").toInt());
                    img.setPixelColor(x, y, color);
                }
            }

            m_img.setImage(img);

        } catch (int e) {
            qDebug() << "QtDarkerFilter. Exception Nr. " << e << '\n';
            return false;
        }
    }
    return true;
}

