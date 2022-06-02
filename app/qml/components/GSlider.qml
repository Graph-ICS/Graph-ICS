import QtQuick 2.15
import QtQuick.Controls 2.15

import Theme 1.0

Slider {
    id: control

    property alias valueIndicator: valueIndicator
    property alias toIndicator: toIndicator
    property alias toolTip: toolTip
    property color rangeColor: Theme.primary

    snapMode: Slider.NoSnap
    stepSize: 1
    from: 0
    to: 1000
    hoverEnabled: true

    height: Theme.largeHeight

    background: Rectangle {
        x: control.leftPadding + control.handle.width / 2
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: 6

        width: control.availableWidth - control.handle.width
        height: implicitHeight

        color: Theme.onsurface
        opacity: enabled ? Theme.opacity.normal : Theme.opacity.disabled

        Rectangle {
            width: control.handle.x - control.handle.width / 2
            height: parent.height
            color: rangeColor
        }

        Text {
            id: toIndicator

            property int topOffset: (handle.height - background.height) / 2

            anchors.top: parent.bottom
            anchors.topMargin: topOffset
            anchors.right: parent.right
            anchors.rightMargin: -control.handle.width / 2

            text: String(control.to)
            color: Theme.onsurface
            font: Theme.font.overline
        }
    }

    handle: Rectangle {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 12
        implicitHeight: implicitWidth
        radius: implicitWidth / 2
        color: Theme.surface
        border.width: 1
        border.color: Theme.onsurface

        Rectangle {
            id: overlay
            anchors.fill: parent
            radius: parent.radius
            color: valueIndicator.color
            opacity: pressed
                     || !enabled ? Theme.opacity.pressed : hovered ? Theme.opacity.hover : 0.0
        }

        Text {
            id: valueIndicator

            property int xOffset: -width / 2 + parent.width / 2

            anchors.bottom: parent.top

            x: {
                let pos = parent.x + xOffset + width - parent.width / 2
                if (pos > control.availableWidth) {
                    return control.availableWidth - pos + xOffset
                } else {
                    return xOffset
                }
            }

            text: String(control.value)
            color: Theme.onsurface
            opacity: enabled ? Theme.opacity.normal : Theme.opacity.disabled
            font: Theme.font.overline
        }
    }

    GToolTip {
        id: toolTip
        text: ""
        parent: control.handle
        visible: control.hovered && !control.pressed && text != ""
    }
}
