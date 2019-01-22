import QtQuick 2.9

Rectangle {
    id: port
    width: 30
    height: width
    y: parent.height / 2 - height /2
    color: "transparent"

    property alias viewPort: viewPort
    property string defaultColor: "white"

    property int absX: x + parent.absX
    property int absY: y + parent.absY

    property var isHovered: canvas.mouseArea.inRect2(absX, absY, width, height)
    property bool isConnected: false

    function resetColor() {
        viewPort.color = defaultColor;
    }

    function resetDefaultColor() {
        defaultColor = "white";
    }

    Rectangle {
        id: viewPort
        width: 10
        height: width
        y: port.height / 2 - height / 2
        color: "white"

        property int absX: x + parent.absX
        property int absY: y + parent.absY
        property int absCenterX: absX + width / 2
        property int absCenterY: absY + height / 2
    }
}



