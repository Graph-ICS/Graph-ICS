#include "qtlighterfilter.h"

#include <QDebug>

QtLighterFilter::QtLighterFilter()
{
    registerAttribute("factor", new NodeIntAttribute(200, 1000));
    m_nodeName = "QtLighter";
}

bool QtLighterFilter::retrieveResult(){

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
                    QColor color = img.pixelColor(x, y);
                    color = color.lighter(getAttributeValue("factor").toInt());
                    img.setPixelColor(x, y, color);
                }
            }

            m_img.setImage(img);

        } catch (int e) {
            qDebug() << "QtLighterFilter. Exception Nr. " << e << '\n';
            return false;
        }
    }
    return true;
}
