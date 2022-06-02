#include "gdata.h"
#include <QDebug>

GData::GData()
{
}

bool GData::isEmpty()
{
    return m_pointSetData.isEmpty() && m_barSetData.isEmpty();
}

void GData::clear()
{
    m_pointSetData.clear();
    m_barSetData.clear();
}

void GData::appendPoint(const QString& label, const QColor& color, const QPointF& point, const int& bufferSize)
{
    for (auto pointSet : m_pointSetData)
    {
        if (pointSet.label == label)
        {
            pointSet.color = color;
            pointSet.data.append(point);
            int diff = pointSet.data.size() - bufferSize;
            while (diff > 0)
            {
                pointSet.data.pop_front();
                diff--;
            }
            break;
        }
    }
}

void GData::setData(const PointSet& data)
{
    clear();
    m_pointSetData.append(data);
}

void GData::setData(const QList<PointSet>& data)
{
    clear();
    m_pointSetData = data;
}

// const QList<QtCharts::QBarSet*>& GData::getBarSetData()
//{
//    if (m_barSetData.isEmpty())
//    {
//        convertPointSetDataToBarSetData();
//    }
//    return m_barSetData;
//}

const QList<PointSet>& GData::getPointSetData()
{
    if (m_pointSetData.isEmpty())
    {
        convertBarSetDataToPointSetData();
    }
    return m_pointSetData;
}

GData::Pointer GData::getDeepCopy() const
{
    return GData::Pointer(new GData(*this));
}

void GData::convertPointSetDataToBarSetData()
{
    for (auto& pointSet : m_pointSetData)
    {
        QtCharts::QBarSet* barSet = new QtCharts::QBarSet(pointSet.label);
        barSet->setColor(pointSet.color);
        for (auto& point : pointSet.data)
        {
            barSet->append(point.y());
        }
        m_barSetData.append(barSet);
    }
}

void GData::convertBarSetDataToPointSetData()
{
    for (int i = 0; i < m_barSetData.size(); i++)
    {
        PointSet pointSet;
        pointSet.label = m_barSetData[i]->label();
        pointSet.color = m_barSetData[i]->color();

        int valueIndex = 0;
        // https://doc.qt.io/qt-5/qbarset.html#at (checked on 25.08.2021)
        // If the index is out of bounds, 0.0 is returned
        qreal barSetValue = m_barSetData[i]->at(valueIndex);
        while (barSetValue != 0.0)
        {
            pointSet.data.append(QPointF(valueIndex, barSetValue));
            valueIndex++;
            barSetValue = m_barSetData[i]->at(valueIndex);
        }

        m_pointSetData.append(pointSet);
    }
}
