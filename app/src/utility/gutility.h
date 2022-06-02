#ifndef GUTILITY_H
#define GUTILITY_H

#include <QObject>
#include <QRectF>

class GUtility : public QObject
{
    Q_OBJECT
public:
    explicit GUtility(QObject* parent = nullptr);

    Q_INVOKABLE bool intersects(const QRectF& rect1, const QRectF& rect2);
};

#endif // GUTILITY_H
