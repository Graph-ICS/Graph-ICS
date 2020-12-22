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
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top

    anchors.topMargin: 10

    text: parent.isCached ? parent.objectName : parent.objectName + "*"
    color: Theme.node.color.text.normal
    font.family: Theme.font.family
    font.pointSize: Theme.font.pointSize
    font.bold: true

    function getBounds(){
        return {"w": width + 24, "h": font.pointSize + 21}
    }
}
