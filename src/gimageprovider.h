#ifndef GIMAGEPROVIDER_H
#define GIMAGEPROVIDER_H

#include <QObject>
#include <QPixmap>
#include <QQuickImageProvider>

class GImageProvider : public QObject, public QQuickImageProvider
{
    Q_OBJECT
    Q_PROPERTY(QPixmap img READ getImg WRITE setImg NOTIFY imgChanged)

public:
    explicit GImageProvider();
    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize);

    const QPixmap& getImg() { return m_img; }
    void setImg(const QPixmap& img);
    Q_INVOKABLE void removeImg();
    //
    Q_INVOKABLE virtual QPixmap loadImage(QString path);
    //

//public slots:
//    void updateImage(const QPixmap &image) {}

signals:
    void imgChanged();

private:
    QPixmap m_img;
};


#endif // GIMAGEPROVIDER_H
