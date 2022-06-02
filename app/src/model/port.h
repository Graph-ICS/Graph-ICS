#ifndef PORT_H
#define PORT_H

#include <QMap>

#include "gdata.h"
#include "gimage.h"

/*!
 * \brief The Port class
 * \details a Port instance can be registered as an inPort or outPort in the Node class. The inPorts specify the input
 * the Node needs to calculate its result. The outPorts specify the possible results of the Node. Port also handles the
 * cacheing of the Node results.
 */
namespace G
{
class Port
{
    Q_GADGET
public:
    enum TYPE
    {
        UNDEFINED,
        GIMAGE,
        GDATA
    };
    Q_ENUM(TYPE)

    Port(const TYPE& type, bool isRequired = true);

    TYPE getType() const;
    bool isRequired() const;

    bool hasConnectedPort() const;
    Port* getConnectedPort() const;

    void connectPort(Port* outPort);
    void disconnectPort();

    void setGImage(GImage::Pointer image);
    void setGData(GData::Pointer data);

    GImage::Pointer getGImage() const;
    GData::Pointer getGData() const;

    void setCacheingAllowed(const bool& isCacheingAllowed);
    void cacheResult(const int& frameId);
    bool hasCache(const int& frameId) const;
    void retrieveCache(const int& frameId);
    void clearCache();

private:
    TYPE m_type;
    bool m_isRequired;

    Port* m_connectedPort;

    GImage::Pointer m_image;
    GData::Pointer m_data;

    bool m_isCacheingAllowed;

    QMap<int, GImage::Pointer> m_cachedImages;
    QMap<int, GData::Pointer> m_cachedData;
};
} // namespace G

#endif // PORT_H
