import QtQuick 2.0
import QtQuick.Controls 2.15
import QtCharts 2.15
import Theme 1.0
import Model.DiagramView 1.0

GView {

    model: DiagramViewModel {
        id: model
        Component.onCompleted: {
            model.setAxes(xAxis, yAxis)
        }
    }

    menuActions: [
        Action {
            text: "Reset Zoom"
            onTriggered: {
                // TODO - Bug: resets to the last coordinate state after clear was called
                chartView.zoomReset()
            }
        }
    ]

    ChartView {
        id: chartView

        anchors.fill: parent
        antialiasing: true
        backgroundColor: Theme.background
        titleColor: Theme.onsurface
        plotAreaColor: Theme.background

        legend.color: Theme.onsurface
        legend.borderColor: "black"
        legend.labelColor: Theme.onsurface
        legend.visible: true

        ValueAxis {
            id: xAxis
            color: Theme.onsurface
            labelsColor: Theme.onsurface
            gridVisible: false

            labelsFont: Theme.font.caption
            titleFont: Theme.font.h6
        }
        ValueAxis {
            id: yAxis
            color: Theme.onsurface
            gridLineColor: Theme.onsurface
            labelsColor: Theme.onsurface
            gridVisible: true

            labelsFont: Theme.font.caption
            titleFont: Theme.font.h6
        }

        MouseArea {
            id: ma
            anchors.fill: parent

            // TODO: drag&drop ma interferes
            onDoubleClicked: {
                chartView.zoomReset()
            }

            onWheel: {
                if (wheel.angleDelta.y > 0) {
                    chartView.zoom(1.1)
                } else {
                    chartView.zoom(0.9)
                }
            }
        }
    }

    Connections {
        target: model

        function onUpdated() {
            updated()
        }

        function onCreateSeries() {
            var series = chartView.createSeries(ChartView.SeriesTypeLine, "",
                                                xAxis, yAxis)

            model.setSeries(series)
        }

        function onCleared() {
            chartView.removeAllSeries()
        }
    }

    function removeDiagram() {
        model.clear()
    }
}
