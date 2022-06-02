#ifndef IMAGEVIEW_H
#define IMAGEVIEW_H

#include "gimageprovider.h"
#include "view.h"

namespace G
{
class ImageView : public View
{
    Q_OBJECT
public:
    ImageView();
    ~ImageView();

    Q_INVOKABLE QString getImageProviderPath() const;

    bool retrieveResult() override;
    Q_INVOKABLE void clear() override;

private:
    Port m_imageInPort;
    GImageProvider* m_imageProvider;
    const QString m_imageProviderPath;

    static unsigned int numberOfCreatedInstances;
};
} // namespace G

#endif // IMAGEVIEW_H
