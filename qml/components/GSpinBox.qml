import QtQuick 2.12
import QtQuick.Controls 2.12

import Theme 1.0

SpinBox {
    id: control
    editable: true
    property color pressedColor: "gray"
    height: text.font.pointSize + 16
    contentItem: TextInput {
        id: text
        z: 2
        text: control.textFromValue(control.value, control.locale)
        anchors.centerIn: bg

        font.family: Theme.font.family
        font.pointSize: Theme.font.pointSize
        color: Theme.textField.color.text.normal
        selectionColor: Theme.textField.color.text.select
        selectedTextColor: Theme.accentColor

        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter

        readOnly: !control.editable
        validator: control.validator
        inputMethodHints: Qt.ImhFormattedNumbersOnly
    }

    up.indicator: Rectangle {
        x: control.mirrored ? 3 : parent.width - width - 3
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height - 6
        width: height
        color: enabled ? control.up.pressed ? control.pressedColor : Theme.textField.color.background.disable : Theme.textField.color.background.normal
//        border.color: Theme.textField.color.background.normal
//        border.width: 2
        radius: 1
        Text {
            text: "+"
            font.pointSize: Theme.font.pointSize
            color: parent.enabled ? control.up.pressed ? "white" : Theme.textField.color.text.normal : Theme.textField.color.text.normal
            anchors.fill: parent
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    down.indicator: Rectangle {
        x: control.mirrored ? parent.width - width - 3 : 3
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height - 6
        width: height
        color: enabled ? control.down.pressed ? control.pressedColor : Theme.textField.color.background.disable : Theme.textField.color.background.normal
//        border.color: Theme.textField.color.background.normal
//        border.width: 2
        radius: 1

        Text {
            text: "-"
            font.pointSize: Theme.font.pointSize
            color: parent.enabled ? control.down.pressed ? "white" : Theme.textField.color.text.normal : Theme.textField.color.text.normal
            anchors.fill: parent
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    background: Rectangle {
        id: bg
        color: Theme.textField.color.background.normal
        implicitWidth: 96
        border.color: Theme.textField.color.background.normal
        border.width: 2
        radius: 1
    }
}
