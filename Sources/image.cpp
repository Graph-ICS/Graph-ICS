#include "image.h"
#include <QDebug>
#include <QImage>
//
#include "imageconverter.h"

Image::Image() {
}

void Image::setPath(const QString& path)
{
    if (m_path == path)
        return;
    //qDebug() << path ;
    m_path = path;
    cleanCache();
    emit pathChanged();
}

bool Image::retrieveResult()
{
    if(!(m_img.isNull())){
        return true;
    }
    try {
        if (!m_path.isEmpty()) {
            QPixmap img(m_path);
            m_img = img;
        }
        else {
            m_img = QPixmap();
        }
    } catch (int e) {
        qDebug()  << "Image. Exception Nr. " << e << '\n';
        return false;
    }
    return true;
}

void Image::cleanCache()
{
    if(m_outNodes.size() > 0){
        for (int i = 0; i < m_outNodes.size(); ++i) {
            m_outNodes.at(i)->cleanCache();
        }
    }
    m_img = QPixmap();
}
