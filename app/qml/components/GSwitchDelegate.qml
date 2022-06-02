import QtQuick 2.12
import QtQuick.Controls 2.12

import Theme 1.0

SwitchDelegate {
    id: control
    text: "SwitchDelegate"
    checked: true

    property color textColorChecked: Theme.onsurface
    property color textColor: Theme.onsurface
    property color switchColorChecked: Theme.primary
    property color switchColor: Theme.onsurface

    contentItem: Text {
        rightPadding: control.indicator.width + control.spacing
        text: control.text

        font: Theme.font.body2

        opacity: enabled ? 1.0 : 0.3
        color: control.checked ? textColorChecked : textColor
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }

    indicator: Rectangle {
        implicitWidth: 34
        implicitHeight: 18
        x: control.width - width - control.rightPadding
        y: parent.height / 2 - height / 2
        radius: 13
        color: control.checked ? switchColorChecked : "transparent"
        border.color: control.checked ? switchColorChecked : switchColor
        border.width: 2

        Rectangle {
            x: control.checked ? parent.width - width - 4 : 4
            anchors.verticalCenter: parent.verticalCenter
            width: 10
            height: 10
            radius: 13
            color: control.checked ? Theme.onprimary : switchColor
        }
    }

    background: Rectangle {
        visible: false
    }
}
