
#include "gimageprovider.h"


GImageProvider::GImageProvider()
    : QQuickImageProvider(QQuickImageProvider::Pixmap),
      m_img(1, 1)
{
    m_img.fill(Qt::transparent);
}

void GImageProvider::setImg(const QPixmap& img)
{
    m_img = img;
    emit imgChanged();
}

QPixmap GImageProvider::loadImage(QString path)
{
    QPixmap image (path);
    return image;
}

void GImageProvider::saveImageToFile(QPixmap image, QString path)
{
    path.remove(0,8);
    QImage qimage = image.toImage();
    qimage.save(path);
}

QPixmap GImageProvider::requestPixmap(const QString& /*id*/, QSize* /*size*/, const QSize& /*requestedSize*/)
{
    return m_img;
}

