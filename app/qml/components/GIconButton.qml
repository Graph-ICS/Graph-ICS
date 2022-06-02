import QtQuick 2.15
import QtQuick.Controls 2.15

import Theme 1.0

Button {
    id: control

    property color backgroundColor: Theme.surface
    property bool transparent: false

    property alias toolTip: toolTip

    hoverEnabled: true
    padding: 0

    opacity: control.enabled ? Theme.opacity.normal : Theme.opacity.disabled
    icon.color: Theme.onsurface

    display: Button.IconOnly

    background: Rectangle {
        implicitWidth: 42
        implicitHeight: 42

        visible: !transparent
        color: backgroundColor

        Rectangle {
            id: overlay
            anchors.fill: parent
            color: icon.color
            opacity: control.pressed ? Theme.opacity.pressed : control.hovered ? Theme.opacity.hover : 0.0
        }
    }

    GToolTip {
        id: toolTip
    }
}
