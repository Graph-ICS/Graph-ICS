import QtQuick 2.15
import QtQuick.Controls 2.15

import Theme 1.0

Slider {
    id: control

    property string handleColor: Theme.secondaryDark

    property alias markerLine: markerLine
    property int markerHeight: 100

    snapMode: Slider.SnapAlways
    stepSize: 1
    from: 0
    to: 1000
    hoverEnabled: true

    height: Theme.largeHeight

    background: Rectangle {
        color: "transparent"
    }

    handle: Rectangle {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2

        height: 12
        width: 12
        color: "transparent"

        Canvas {
            anchors.centerIn: parent
            width: 16
            height: 12
            onPaint: {
                var ctx = getContext("2d")
                ctx.moveTo(0, 0)
                ctx.lineTo(width, 0)
                ctx.lineTo(width / 2, height)
                ctx.closePath()
                ctx.fillStyle = handleColor
                ctx.fill()
            }
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
            font: Theme.font.overline
        }
        Rectangle {
            id: markerLine
            color: handleColor
            width: 3
            height: markerHeight
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
        }
    }
}
