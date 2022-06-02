#ifndef DIAGRAMVIEW_H
#define DIAGRAMVIEW_H

#include <QMutex>
#include <QWaitCondition>
#include <QtCharts/QAbstractSeries>
#include <QtCharts>
#include <view.h>

namespace G
{
class DiagramView : public View
{
    Q_OBJECT
public:
    DiagramView();

    Q_INVOKABLE void setSeries(QtCharts::QAbstractSeries* series);
    Q_INVOKABLE void setAxes(QtCharts::QValueAxis* xAxis, QtCharts::QValueAxis* yAxis);

    bool retrieveResult() override;
    Q_INVOKABLE void clear() override;

signals:
    void createSeries();

private:
    Port m_inPort;
    QVector<QtCharts::QXYSeries*> m_XYSeries;

    QtCharts::QValueAxis* m_xAxis;
    QtCharts::QValueAxis* m_yAxis;

    QMutex m_mutex;
    QWaitCondition m_condition;
};
} // namespace G
#endif // DIAGRAMVIEW_H
