import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2


import Theme 1.0
import "../"
import "../components/"

// NodeTitle nur in verwendung als Child von GNode oder GFilter
// Anwendung beim implementieren einer Custom NodeView siehe ItkCannyEdgeDetectionFilter.qml
// oder QmlStringCreator.qml

QQC2.Label {
    id: innerText
    property string title: parent.number === 1 ? parent.objectName : parent.objectName + "(" + String(parent.number) + ")"
    anchors.horizontalCenter: parent.horizontalCenter
//    anchors.left: parent.left
//    anchors.leftMargin: 10
    anchors.top: parent.top
    anchors.topMargin: 10

    property var indicators: []
    property bool isCached: false
    text: isCached ? title : title + "*"
    font.underline: parent.isShown
    color: Theme.node.color.text.normal
    font.family: Theme.font.family
    font.pointSize: Theme.font.pointSize
    font.bold: true

    function getBounds(){
        var textWidth = implicitWidth + 21
        var boundWidth = textWidth
        var boundHeight = font.pointSize + 21
        if(indicators.length > 0){
            var indicatorsWidth = indicators.length * 12 + indicators.length * 3 + 17
            if(textWidth < indicatorsWidth){
                boundWidth = indicatorsWidth
            }
            boundHeight += 12
        }

        return {"w": boundWidth , "h": boundHeight}
    }

    function addViewIndicator(color){
        var rect = Qt.createQmlObject("import QtQuick 2.15; Rectangle {}", innerText.parent)
        rect.height = 12
        rect.radius = 4
        rect.width = rect.height
        rect.anchors.bottom = innerText.top
        rect.anchors.bottomMargin = 3
        rect.anchors.left = rect.parent.left

        innerText.anchors.topMargin = 22
        rect.color = color
        var indSize = indicators.length * 12 + 3*indicators.length + 8
        rect.anchors.leftMargin = indSize

        indicators.push(rect)
        parent.rect.calculateNodeSize()
    }

    function removeViewIndicator(color){
        var foundPos
        var found = false
        for(var i = 0; i < indicators.length; i++){
            if(found){
                var size = i
                size--
                indicators[i].anchors.leftMargin = size * 12 + 3*size + 10
            }
            if(indicators[i].color === color){
                foundPos = i
                found = true
            }
        }
        indicators[foundPos].destroy()
        indicators.splice(foundPos, 1)
        parent.rect.calculateNodeSize()
        if(indicators.length == 0){
            innerText.anchors.topMargin = 10
        }
    }

}
