
#include "gimageprovider.h"


GImageProvider::GImageProvider()
    : QQuickImageProvider(QQuickImageProvider::Pixmap)
      //m_img(1, 1)
{
//    m_img.getQPixmap().fill(Qt::transparent);
}

void GImageProvider::setImg(const GImage& img)
{
    m_img = img;
    emit imgChanged();
}

QPixmap GImageProvider::loadImage(QString path)
{
    QPixmap image (path);
    return image;
}

QPixmap GImageProvider::requestPixmap(const QString& /*id*/, QSize* /*size*/, const QSize& /*requestedSize*/)
{
    return m_img.getQPixmap();
}

