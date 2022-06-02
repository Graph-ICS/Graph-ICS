import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15

import Theme 1.0

RangeSlider {
    id: control

    property alias firstValueIndicator: firstValueIndicator
    property alias secondValueIndicator: secondValueIndicator

    property alias firstToolTip: firstToolTip
    property alias secondToolTip: secondToolTip

    property color rangeColor: Theme.primary

    snapMode: Slider.SnapAlways
    stepSize: 1
    from: 0
    to: 1000
    hoverEnabled: true

    height: Theme.largeHeight

    background: Rectangle {
        x: control.leftPadding + control.first.handle.width / 2
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: 6

        width: control.availableWidth - control.first.handle.width
        height: implicitHeight

        color: Theme.onsurface
        opacity: enabled ? Theme.opacity.normal : Theme.opacity.disabled

        Rectangle {
            x: control.first.visualPosition * parent.width
            width: control.second.visualPosition * parent.width - x
            height: parent.height
            color: rangeColor
        }

        Text {
            id: toIndicator

            property int topOffset: (second.handle.height - background.height) / 2

            anchors.top: parent.bottom
            anchors.topMargin: topOffset
            anchors.right: parent.right
            anchors.rightMargin: -control.first.handle.width / 2

            text: String(control.to)
            color: Theme.onsurface
            font: Theme.font.overline
        }
    }

    GToolTip {
        id: firstToolTip
        parent: first.handle
        text: ""
        visible: first.hovered && !first.pressed && text != ""
    }

    GToolTip {
        id: secondToolTip
        parent: second.handle
        text: ""
        visible: second.hovered && !second.pressed && text != ""
    }

    first.handle: Rectangle {
        x: control.leftPadding + control.first.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 12
        implicitHeight: implicitWidth
        radius: implicitWidth / 2
        color: Theme.surface
        border.width: 1
        border.color: Theme.onsurface

        Rectangle {
            id: overlayFirst
            anchors.fill: parent
            radius: parent.radius
            color: firstValueIndicator.color
            opacity: first.pressed
                     || !enabled ? Theme.opacity.pressed : hovered ? Theme.opacity.hover : 0.0
        }

        Text {
            id: firstValueIndicator

            visible: first.value != second.value

            anchors.bottom: parent.top
            anchors.right: parent.left
            anchors.rightMargin: {
                let val = secondValueIndicator.parent.x + secondValueIndicator.x
                    - parent.x - parent.width

                if (val < 0) {
                    return -parent.width / 2 - val
                }

                return -parent.width / 2
            }

            text: String(Math.trunc(first.value))
            color: Theme.onsurface
            opacity: enabled ? Theme.opacity.normal : Theme.opacity.disabled
            font: Theme.font.overline
        }
    }

    second.handle: Rectangle {
        x: control.leftPadding + control.second.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 12
        implicitHeight: implicitWidth
        radius: implicitWidth / 2
        color: Theme.surface
        border.width: 1
        border.color: Theme.onsurface

        Rectangle {
            id: overlaySecond
            anchors.fill: parent
            radius: parent.radius
            color: secondValueIndicator.color
            opacity: second.pressed
                     || !enabled ? Theme.opacity.pressed : hovered ? Theme.opacity.hover : 0.0
        }
        Text {
            id: secondValueIndicator

            property int xOffset: parent.width / 2

            Binding on xOffset {
                when: control.first.value == control.second.value
                value: -secondValueIndicator.width / 2 + secondValueIndicator.parent.width / 2
                restoreMode: Binding.RestoreBindingOrValue
            }

            anchors.bottom: parent.top

            x: {
                let pos = parent.x + xOffset + width - parent.width / 2
                if (pos > control.availableWidth) {
                    return control.availableWidth - pos + xOffset
                } else {
                    return xOffset
                }
            }

            text: String(Math.trunc(second.value))
            color: Theme.onsurface
            opacity: enabled ? Theme.opacity.normal : Theme.opacity.disabled
            font: Theme.font.overline
        }
    }
}
