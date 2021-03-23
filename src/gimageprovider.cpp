
#include "gimageprovider.h"


GImageProvider::GImageProvider()
    : QQuickImageProvider(QQuickImageProvider::Pixmap),
      m_img(QPixmap())
{
//    m_img.getQPixmap().fill(Qt::transparent);
}

void GImageProvider::setImg(const QPixmap& img)
{
    m_img = img;
    emit imgChanged();
}

void GImageProvider::removeImg()
{
    m_img = QPixmap();
}

QPixmap GImageProvider::loadImage(QString path)
{
    QPixmap image (path);
    return image;
}

QPixmap GImageProvider::requestPixmap(const QString& /*id*/, QSize* /*size*/, const QSize& /*requestedSize*/)
{
    return m_img;
}

