#include "port.h"
#include "node.h"

namespace G
{

Port::Port(const TYPE& type, bool isRequired)
    : m_type(type)
    , m_isRequired(isRequired)
    , m_connectedPort(nullptr)
    , m_image(new GImage())
    , m_data(new GData())
    , m_cachedImages()
    , m_cachedData()
{
    m_isCacheingAllowed = true;
}

Port::TYPE Port::getType() const
{
    return m_type;
}

bool Port::isRequired() const
{
    return m_isRequired;
}

bool Port::hasConnectedPort() const
{
    return m_connectedPort != nullptr;
}

Port* Port::getConnectedPort() const
{
    return m_connectedPort;
}

void Port::connectPort(Port* outPort)
{
    m_connectedPort = outPort;
}

void Port::disconnectPort()
{
    m_connectedPort = nullptr;
}

void Port::setGImage(GImage::Pointer image)
{
    m_image = image;
}

void Port::setGData(GData::Pointer data)
{
    m_data = data;
}

GImage::Pointer Port::getGImage() const
{
    return m_image;
}

GData::Pointer Port::getGData() const
{
    return m_data;
}

void Port::setCacheingAllowed(const bool& isCacheingAllowed)
{
    m_isCacheingAllowed = isCacheingAllowed;
}

void Port::cacheResult(const int& frameId)
{
    if (m_isCacheingAllowed)
    {
        switch (m_type)
        {
            case UNDEFINED:
                break;
            case GIMAGE:
                m_cachedImages[frameId] = m_image->getDeepCopy();
                m_cachedImages[frameId]->compressToJpeg();
                break;
            case GDATA:
                m_cachedData[frameId] = m_data->getDeepCopy();
                break;
        }
    }
}

bool Port::hasCache(const int& frameId) const
{
    switch (m_type)
    {
        case UNDEFINED:
            return false;
            break;
        case GIMAGE:
            return m_cachedImages.contains(frameId);
            break;
        case GDATA:
            return m_cachedData.contains(frameId);
            break;
    }
    return false;
}

void Port::retrieveCache(const int& frameId)
{
    if (m_type == UNDEFINED)
    {
    }
    if (m_type == GIMAGE)
    {
        m_image = m_cachedImages[frameId]->getDeepCopy();
    }
    if (m_type == GDATA)
    {
        m_data = m_cachedData[frameId]->getDeepCopy();
    }
}

void Port::clearCache()
{
    m_image = QSharedPointer<GImage>(new GImage());
    m_data = QSharedPointer<GData>(new GData());
    m_cachedImages.clear();
    m_cachedData.clear();
}

} // namespace G
