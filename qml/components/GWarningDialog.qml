import QtQuick 2.10
import QtQuick.Controls 2.15

import QtQuick.Window 2.11

import Theme 1.0

Window {
    id: graphics_WarningDialog


    property alias text: label.text

    title: "Graph-ICS - Warning!"

    width: 324
    minimumWidth: 324
    maximumWidth: 324
    height: label.implicitHeight + button.height + 48
    color: Theme.mainColor

    Text {
        id : label
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.right: parent.right
        anchors.margins: 24
        anchors.top: parent.top
        color: Theme.contentDelegate.color.text.hover
        font.pointSize: Theme.font.pointSize
        font.family: Theme.font.family
        wrapMode: Text.WordWrap
        height: implicitHeight
        width: implicitWidth
    }

    GButton {
        id: button

        text: "got it!"

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: label.bottom
        anchors.margins: 12

        width: 72
        height: 28

        onClicked: {
            graphics_WarningDialog.close()
            content.state = 'normal'
        }
    }
}
