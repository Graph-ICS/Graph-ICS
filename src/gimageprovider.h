#ifndef GIMAGEPROVIDER_H
#define GIMAGEPROVIDER_H

#include <QObject>
#include <QPixmap>
#include <QQuickImageProvider>
#include "gimage.h"

class GImageProvider : public QObject, public QQuickImageProvider
{
    Q_OBJECT
    Q_PROPERTY(GImage img READ getImg WRITE setImg NOTIFY imgChanged)

public:
    explicit GImageProvider();
    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize);

    const GImage& getImg() { return m_img; }
    void setImg(const GImage& img);

    //
    Q_INVOKABLE virtual QPixmap loadImage(QString path);
    //

//public slots:
//    void updateImage(const QPixmap &image) {}

signals:
    void imgChanged();

private:
    GImage m_img;
};


#endif // GIMAGEPROVIDER_H
