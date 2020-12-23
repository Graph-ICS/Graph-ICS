import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.12

import Theme 1.0

Item {
    id: graphics_VideoControl
    signal play()
    signal pause()
    signal stop()

    property int margin: 4
    property var color: QtObject {
        property color normal: Theme.contentDelegate.color.text.normal
        property color hover: Theme.node.color.border.hover
    }

    property alias paused: playPauseButton.paused

    GButton {
        id: playPauseButton
        height: parent.height
        width: height
        transparent: true
        anchors.left: parent.left
        anchors.leftMargin: margin
        anchors.verticalCenter: parent.verticalCenter
        property bool paused: true
        Image {
            id: playPauseIcon
            anchors.fill: parent
            source: parent.paused ? "qrc:/img/play.svg" : "qrc:/img/pause.svg"
            fillMode: Image.PreserveAspectFit
        }

        ColorOverlay {
            id: playPauseColor
            anchors.fill: playPauseIcon
            source: playPauseIcon
            color: graphics_VideoControl.color.normal
        }

        onClicked: {
            forceActiveFocus()
            if(paused) {
                paused = false
                play()
            } else {
                paused = true
                pause()
            }
        }

        onEnabledChanged: {
            if(enabled)
                playPauseColor.color = color.normal
            else
                playPauseColor.color =  color.disable
        }

        onEntered: {
            playPauseColor.color = color.hover
        }
        onExited: {
            playPauseColor.color = color.normal
        }
    }

    GButton {
        id: stopButton
        height: parent.height
        width: height
        transparent: true
        anchors.left: playPauseButton.right
        anchors.leftMargin: margin
        anchors.verticalCenter: parent.verticalCenter
        Image {
            id: stopIcon
            anchors.fill: parent
            source: "qrc:/img/stop.svg"
            fillMode: Image.PreserveAspectFit
        }
        ColorOverlay {
            id: stopColor
            anchors.fill: stopIcon
            source: stopIcon
            color: graphics_VideoControl.color.normal
        }

        onClicked: {
            forceActiveFocus()
            stop()
        }

        onEntered: {
            stopColor.color = color.hover
        }
        onExited: {
            stopColor.color = color.normal
        }
    }

}
