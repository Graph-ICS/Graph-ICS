import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2

import Theme 1.0

// This Item is used in the StatusBar - ListView to display the queued processing jobs

Item {
    id: graphics_StatusBarDelegate
    property string text: "placeholderText"
    property string inputNode: ""
    property var node: null

    property alias videoControls: videoControl

    height: ma.height + 14
    width: 196

    FishSpinner {
        id: loadingAnimation
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        radius: 10
        color: Theme.accentColor
        visible: !videoControl.paused
    }

    MouseArea {
        id: ma
        anchors.left: loadingAnimation.right
        anchors.leftMargin: 12
        anchors.verticalCenter: loadingAnimation.verticalCenter
        acceptedButtons: Qt.RightButton
        height: label.implicitHeight
        width: label.implicitWidth
        QQC2.Label {
            id: label
            anchors.fill: parent
            text: graphics_StatusBarDelegate.text
            color: Theme.contentDelegate.color.text.hover
            font.pointSize: Theme.font.pointSize
            font.family: Theme.font.family
        }
    }

    Rectangle {
        id: bottomLine
        anchors.left: parent.left
        anchors.leftMargin: -8
        anchors.right: parent.right
        anchors.top: parent.bottom
        height: 1
        color: Theme.darkMode ? Theme.contentDelegate.color.background.normal : Theme.contentDelegate.color.background.press
    }

    GVideoControlPanel {
        id: videoControl
        anchors.left: bottomLine.right
        anchors.verticalCenter: ma.verticalCenter
        anchors.leftMargin: 4
        paused: false
        height: 22
        width: height*2 + 8

        onPlay: {
            scheduler.resumeNode(node.model)
        }
        onPause: {
            scheduler.suspendNode(node.model)
        }
        onStop: {
            scheduler.stopNode(node.model)
            stopButton.enabled = false
        }
    }

    function disableStop(){
        videoControl.stopButton.enabled = false
    }

//    GMenu {
//        id: menu
//        QQC2.Action {
//            text: "remove Task"
//            enabled: !firstElement
//            onTriggered: {
//                removeTask(graphics_StatusBarDelegate.index)
//            }
//        }
//    }

}
