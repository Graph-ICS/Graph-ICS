import QtQuick 2.0
import QtGraphicalEffects 1.12

DropShadow {
    property var target: null

    width: target.width
    height: target.height
    x: target.x
    y: target.y
    visible: target.visible

    source: target

    horizontalOffset: 2
    verticalOffset: 3
    radius: 5
    samples: 7
    color: "black"
}
