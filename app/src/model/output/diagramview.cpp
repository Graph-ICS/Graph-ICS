#include "diagramview.h"
#include <QBarSet>

namespace G
{

DiagramView::DiagramView()
    : View("DiagramView")
    , m_inPort(Port::TYPE::GDATA)
    , m_mutex()
    , m_condition()
{
    registerPorts({&m_inPort}, {});
}

void DiagramView::clear()
{
    m_xAxis->setMax(1);
    m_xAxis->setMin(0);
    m_yAxis->setMax(1);
    m_yAxis->setMin(0);

    m_XYSeries.clear();
    emit cleared();
}

void DiagramView::setSeries(QtCharts::QAbstractSeries* series)
{
    if (series)
    {
        QXYSeries* xyTmp = dynamic_cast<QXYSeries*>(series);
        Q_ASSERT(xyTmp != nullptr);
        m_XYSeries.append(xyTmp);
        m_condition.wakeOne();
    }
}

void DiagramView::setAxes(QValueAxis* xAxis, QValueAxis* yAxis)
{
    m_xAxis = xAxis;
    m_yAxis = yAxis;
}

bool DiagramView::retrieveResult()
{
    if (m_inPort.getGData()->isEmpty())
    {
        clear();
        return false;
    }

    QList<PointSet> pointSetData = m_inPort.getGData()->getPointSetData();
    if (m_XYSeries.size() > pointSetData.size())
    {
        clear();
    }

    while (m_XYSeries.size() < pointSetData.size())
    {
        emit createSeries();
        m_mutex.lock();
        m_condition.wait(&m_mutex);
        m_mutex.unlock();
    }

    qreal Xmin = std::numeric_limits<qreal>::max();
    qreal Xmax = std::numeric_limits<qreal>::min();
    qreal Ymin = std::numeric_limits<qreal>::max();
    qreal Ymax = std::numeric_limits<qreal>::min();

    for (int i = 0; i < m_XYSeries.size(); i++)
    {
        m_XYSeries[i]->setName(pointSetData[i].label);
        m_XYSeries[i]->setColor(pointSetData[i].color);
        m_XYSeries[i]->replace(pointSetData[i].data);

        for (auto& point : pointSetData[i].data)
        {
            qreal x = point.x();
            qreal y = point.y();
            if (Xmax < x)
            {
                Xmax = x;
            }

            if (Xmin > x)
            {
                Xmin = x;
            }

            if (Ymax < y)
            {
                Ymax = y;
            }

            if (Ymin > y)
            {
                Ymin = y;
            }
        }
    }

    m_xAxis->setMax(Xmax);
    m_xAxis->setMin(Xmin);
    m_yAxis->setMax(Ymax);
    m_yAxis->setMin(Ymin);

    emit updated();
    return true;
}
} // namespace G
