#include "image.h"
#include <QDebug>
#include <QImage>
//
#include "imageconverter.h"

Image::Image()
{
    registerAttribute("path",new NodePathAttribute("\"Image files (*.png *.jpg)\",\"All files (*)\""));
    m_inPortCount = 0;
    m_nodeName = "Image";
}

bool Image::retrieveResult()
{
    if(m_img.isSet()){
        return true;
    }
    try {
        QPixmap img(getAttributeValue("path").toString());
        if(!img.isNull()){
            m_img.setImage(img);
        }
        else {
            m_img = GImage();
            return false;
        }
    } catch (int e) {
        qDebug()  << "Image. Exception Nr. " << e << '\n';
        return false;
    }
    return true;
}
