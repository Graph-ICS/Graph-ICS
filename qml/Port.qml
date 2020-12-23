import QtQuick 2.9
import Theme 1.0

Rectangle {
    id: port
    z: -1
    width: 28
    height: width
    color: "transparent"
    radius: 14
    property alias viewPort: viewPort
    property string defaultColor: Theme.node.color.port.normal

    property int absX: x + parent.absX
    property int absY: y + parent.absY

    property var isHovered: canvas.mouseArea.inRect2(absX, absY, width, height)
    property bool isConnected: false

    function resetColor() {
        viewPort.color = defaultColor;
    }

    function resetDefaultColor() {
        defaultColor = Theme.node.color.port.normal
    }

    Rectangle {
        id: viewPort
        width: 12
        height: width
        y: port.height / 2 - height / 2
        color: defaultColor
        radius: 6
        property int absX: x + parent.absX
        property int absY: y + parent.absY
        property int absCenterX: absX + width / 2
        property int absCenterY: absY + height / 2
    }
}



