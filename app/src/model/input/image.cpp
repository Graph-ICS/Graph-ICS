#include "image.h"

#include <QDebug>
#include <QImage>

namespace G
{

Image::Image()
    : Node("Image", INPUT)
    , m_outPort(Port::TYPE::GIMAGE)
    , m_acceptedFiles({".jpg", ".jpeg", ".png"})
    , m_path(attributeFactory.makePathTextField("", m_acceptedFiles, "Image"))
{
    registerPorts({}, {&m_outPort});
    registerAttribute("path", m_path);
}

bool Image::retrieveResult()
{
    QString path = m_path->getValue().toString();
    if (!path.isEmpty())
    {
        QImage img(path);
        if (!img.isNull())
        {
            m_outPort.getGImage()->setImage(img);
            return true;
        }
    }

    return false;
}

QList<QString> Image::getAcceptedFiles() const
{
    return m_acceptedFiles;
}
} // namespace G
