#ifndef GDATA_H
#define GDATA_H

#include <QBarSet>
#include <QList>
#include <QMap>
#include <QPointF>
#include <QVariant>

typedef struct PointSet
{
    QString label = "undefined";
    QColor color = QColor(255, 0, 0);
    QVector<QPointF> data;
} PointSet;

class GData
{
public:
    typedef QSharedPointer<GData> Pointer;

    GData();
    bool isEmpty();
    void clear();

    void appendPoint(const QString& label, const QColor& color, const QPointF& yValue, const int& bufferSize);
    void setData(const PointSet& data);
    void setData(const QList<PointSet>& data);

    //    const QList<QtCharts::QBarSet*>& getBarSetData();
    const QList<PointSet>& getPointSetData();

    GData::Pointer getDeepCopy() const;

private:
    void convertPointSetDataToBarSetData();
    void convertBarSetDataToPointSetData();

    QList<PointSet> m_pointSetData;
    QList<QtCharts::QBarSet*> m_barSetData;
};

#endif // GDATA_H
