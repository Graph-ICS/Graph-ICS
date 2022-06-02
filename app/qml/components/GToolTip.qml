import QtQuick 2.15

import QtQuick.Controls 2.15
import QtGraphicalEffects 1.12

import Theme 1.0

ToolTip {
    id: toolTip
    text: ""
    delay: 1000
    visible: parent.hovered && text != ""
    contentItem: Text {
        text: toolTip.text
        font: Theme.font.caption
        color: Theme.onsurface
    }
    background: Rectangle {
        id: bgRect
        color: Theme.surface
        layer.enabled: true
        layer.effect: GDropShadow {
            target: bgRect
        }
    }
}
