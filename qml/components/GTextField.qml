import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import Theme 1.0


// Custom TextField Component
// used in Nodes

QQC2.TextField {
    id: graphics_TextField

    selectByMouse: true
    selectionColor: Theme.accentColor
    selectedTextColor: Theme.textField.color.text.select
    color: Theme.textField.color.text.normal

    property color borderColor: Theme.textField.color.border.normal
    property alias backgroundColor: bg.color

    background: Rectangle {
        id: bg
        color: Theme.textField.color.background.normal
        radius: 1
        width: parent.width
        height: parent.height
        Rectangle {
            anchors.centerIn: parent
            width: parent.width + 6
            height: parent.height + 6
            color: "transparent"
            border.color: borderColor
            border.width: 2
            radius: 4

            visible: graphics_TextField.activeFocus
        }
    }
    cursorDelegate: Rectangle {
        color: Theme.textField.color.text.normal
        visible: graphics_TextField.activeFocus ? true : false
        width: 1
    }
}
