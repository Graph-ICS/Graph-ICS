#include "imageview.h"

#include "gappinitializer.h"

#include <QQmlApplicationEngine>

namespace G
{

unsigned int ImageView::numberOfCreatedInstances = 0;

ImageView::ImageView()
    : View("ImageView")
    , m_imageInPort(Port::TYPE::GIMAGE)
    , m_imageProvider(new GImageProvider())
    , m_imageProviderPath(QString("gimg" + QString::number(numberOfCreatedInstances)))
{
    registerPorts({&m_imageInPort}, {});
    numberOfCreatedInstances++;

    GAppInitializer::getEngine()->addImageProvider(m_imageProviderPath, m_imageProvider);
}

ImageView::~ImageView()
{
    GAppInitializer::getEngine()->removeImageProvider(m_imageProviderPath);
}

QString ImageView::getImageProviderPath() const
{
    return m_imageProviderPath;
}

bool ImageView::retrieveResult()
{
    GImage::Pointer image = m_imageInPort.getGImage();
    if (image->isEmpty())
    {
        clear();
        return false;
    }
    m_imageProvider->setImg(image->getQPixmap());
    emit updated();
    return true;
}

void ImageView::clear()
{
    m_imageProvider->removeImg();
    emit cleared();
}
} // namespace G
