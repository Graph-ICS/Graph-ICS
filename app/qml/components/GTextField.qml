import QtQuick 2.15
import QtQuick.Controls 2.15
import Theme 1.0

TextField {
    id: textField

    selectByMouse: true
    selectionColor: Theme.primary
    selectedTextColor: Theme.onprimary
    color: Theme.onsurface
    opacity: enabled ? Theme.opacity.normal : Theme.opacity.disabled

    font: Theme.font.body2

    property color borderColor: Theme.onsurface
    property color backgroundColor: Theme.surface

    background: Rectangle {
        id: bg
        color: backgroundColor
        radius: 1
        width: parent.width
        height: parent.height

        Rectangle {
            id: overlay
            color: textField.color
            opacity: textField.activeFocus ? Theme.opacity.pressed : 0.0
        }

        Rectangle {
            anchors.centerIn: parent
            width: parent.width + 6
            height: parent.height + 6
            color: "transparent"
            border.color: borderColor
            border.width: 2
            radius: 4

            visible: textField.activeFocus
        }
    }
    cursorDelegate: Rectangle {
        color: Theme.onsurface
        visible: textField.activeFocus ? true : false
        width: 1
    }
}
