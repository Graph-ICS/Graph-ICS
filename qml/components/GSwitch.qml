import QtQuick 2.15
import QtQuick.Controls 2.15
import Theme 1.0

Switch {
    id: graphics_Switch
    checked: true
//    text: "Switch"
    property color textColorChecked: Theme.contentDelegate.color.text.press
    property color textColor: Theme.contentDelegate.color.text.normal
    property color switchColorChecked: Theme.accentColor
    property color switchColor: Theme.contentDelegate.color.text.normal


    indicator: Rectangle {
        implicitWidth: 34
        implicitHeight: 18
        x: graphics_Switch.width - width - graphics_Switch.rightPadding
        y: parent.height / 2 - height / 2
        radius: 13
        color: graphics_Switch.checked ? switchColorChecked : "transparent"
        border.color: graphics_Switch.checked ? switchColorChecked : switchColor
        border.width: 2

        Rectangle {
            x: graphics_Switch.checked ? parent.width - width - 4 : 4
            anchors.verticalCenter: parent.verticalCenter
            width: 10
            height: 10
            radius: 13
            color: graphics_Switch.checked ? Theme.contentDelegate.color.text.pressAndHold : switchColor
        }
    }

    background: Rectangle {
        visible: false
        height: 0
        width: 0
    }
    HoverHandler {
        cursorShape: hovered ? Qt.PointingHandCursor : Qt.ArrowCursor
    }
}
