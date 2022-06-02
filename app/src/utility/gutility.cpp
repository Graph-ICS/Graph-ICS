#include "gutility.h"

GUtility::GUtility(QObject* parent)
    : QObject(parent)
{
}

bool GUtility::intersects(const QRectF& rect1, const QRectF& rect2)
{
    return rect1.intersects(rect2);
}
