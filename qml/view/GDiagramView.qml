import QtQuick 2.0
import QtCharts 2.15
import Theme 1.0

Rectangle {
    color: Theme.mainColor
    property var currentSeries: null
//    property alias chartView: chartView


    ChartView {
        id: chartView
        title: ""
        anchors.fill: parent
        antialiasing: true
        backgroundColor: /*Theme.contentDelegate.color.background.press*/ Theme.mainColor
        titleColor: Theme.contentDelegate.color.text.press
        plotAreaColor: /*Theme.contentDelegate.color.background.press*/ Theme.mainColor

        legend.color: Theme.contentDelegate.color.text.press
        legend.borderColor: "white"
        legend.labelColor: "white"
        legend.visible: false

//        property alias yAxis: yAxis
//        property alias xAxis: xAxis
//        LineSeries {
//            name: "LineSeries"
//            XYPoint { x: 0; y: 0 }
//            XYPoint { x: 1.1; y: 2.1 }
//            XYPoint { x: 1.9; y: 3.3 }
//            XYPoint { x: 2.1; y: 2.1 }
//            XYPoint { x: 2.9; y: 4.9 }
//            XYPoint { x: 3.4; y: 3.0 }
//            XYPoint { x: 4.1; y: 3.3 }

//            color: Theme.accentColor
//            width: 6

//        }
        MouseArea {
            id: ma
            anchors.fill: parent

            // TODO: drag&drop ma interferes
            onDoubleClicked: {
                chartView.zoomReset()
            }

            onWheel: {
                if(wheel.angleDelta.y > 0){
                    chartView.zoom(1.1)
                } else {
                    chartView.zoom(0.9)
                }

            }
        }

        ValueAxis {
            id: xAxis
            color: "white"
            gridLineColor: "white"
            labelsColor: "white"
            gridVisible: false
            labelsFont.family: Theme.font.family
            labelsFont.pointSize: Theme.font.pointSize
            titleFont.family: Theme.font.family
            titleFont.pointSize: Theme.font.pointSize
        }
        ValueAxis {
            id: yAxis
            color: "white"
            gridLineColor: Theme.contentDelegate.color.text.normal
            labelsColor: "white"
            gridVisible: true
            labelsFont.family: Theme.font.family
            labelsFont.pointSize: Theme.font.pointSize
            titleFont.family: Theme.font.family
            titleFont.pointSize: Theme.font.pointSize
        }

        onSeriesRemoved: {

        }

        onSeriesAdded: {

        }
    }

    IntValidator {
        id: intValidator
    }

    function removeGraph(value){
        if(chartView.count > 0){
            chartView.series(0).removePoints(0, chartView.series(0).count)
        }
        yAxis.visible = value
        xAxis.visible = value
    }

    function createGraph(pointList){
//        pointList.sort(function(a,b) {
//            if( a.x === b.x) return a.y-b.y;
//            return a.x-b.x;
//        })

        var series = chartView.series(0)

        if(chartView.count > 0){
            removeGraph(true)
        } else {
            series = chartView.createSeries(ChartView.SeriesTypeLine, "", xAxis, yAxis)
            series.color = "cyan"
        }

        var minX = intValidator.top
        var maxX = intValidator.bottom
        var minY = intValidator.top
        var maxY = intValidator.bottom

        for(var i = 0; i < pointList.length; i++){
            var x = pointList[i].x
            var y = pointList[i].y
            if(maxX < x){
                maxX = x
            }
            if(minX > x){
                minX = x
            }
            if(maxY < y){
                maxY = y
            }
            if(minY > y){
                minY = y
            }
            series.append(x, y)
        }

        xAxis.min = minX
        xAxis.max = maxX
        yAxis.max = minY
        yAxis.max = maxY

        yAxis.visible = true
        xAxis.visible = true
    }
}
