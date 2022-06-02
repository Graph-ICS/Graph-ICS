import QtQuick 2.9
import QtGraphicalEffects 1.15

import Theme 1.0
import Backend 1.0

Rectangle {
    id: port
    z: -1

    width: 24
    height: width
    color: "transparent"
    radius: width / 2

    property var node: null

    property alias viewPort: viewPort

    property string defaultColor: Theme.onbackground

    property bool isFocused: false
    property string colorOverride: connectedView ? connectedView.backgroundColor : ""
    property var connectedView: null

    property bool isViewConnectionAllowed: !connectedView
    property bool isInput: true

    property int type: {
        if (node.model) {
            if (isInput) {
                return node.model.getInPortType(position)
            } else {
                return node.model.getOutPortType(position)
            }
        }
        return -1
    }

    property int position

    property int absX: x + parent.absX
    property int absY: y + parent.absY

    property bool drawingRectangle: canvas.drawing
    property bool highlighted: {
        if (canvas.hoveredEdge !== -1) {
            if (canvas.edges[canvas.hoveredEdge].portIn === port) {
                return canvas.mouseArea.hoveredEdgeArea === canvas.mouseArea._left
            }
            if (canvas.edges[canvas.hoveredEdge].portOut === port) {
                return canvas.mouseArea.hoveredEdgeArea === canvas.mouseArea._right
            }
        }
        return false
    }
    property bool isHovered: canvas.mouseArea.inRect2(absX, absY, width, height)
    property bool mousePressed: canvas.mouseArea.pressed
                                && (canvas.mouseArea.pressedButtons & Qt.LeftButton)
    property bool edgeAllowed: false
    property bool isFromPort: canvas.hoveredFromPort === port
                              && (canvas.mouseArea.pressedButtons & Qt.LeftButton)
    property bool hasEdge: false
    property bool isConnected: false

    Rectangle {
        id: viewPort

        property int absX: x + parent.absX
        property int absY: y + parent.absY
        property int absCenterX: absX + width / 2
        property int absCenterY: absY + height / 2

        onAbsCenterXChanged: {
            canvas.update()
            canvas.requestPaint()
        }
        onAbsCenterYChanged: {
            canvas.update()
            canvas.requestPaint()
        }

        width: parent.width / 2
        height: width

        anchors.centerIn: parent
        color: {
            if (highlighted) {
                return canvas.hoverColor
            }

            if (!drawingRectangle) {
                if (isHovered) {
                    if (mousePressed) {
                        if (edgeAllowed) {
                            return canvas.edgeColor
                        }
                        return color
                    }
                    return canvas.hoverColor
                }
            }

            if (colorOverride != "") {
                return colorOverride
            }

            if (isConnected || hasEdge || isFromPort) {
                return canvas.edgeColor
            }
            return defaultColor
        }

        radius: width / 2
    }

    Image {
        id: dataTypeIcon
        fillMode: Image.PreserveAspectFit
        anchors.verticalCenter: viewPort.verticalCenter

        anchors.right: isInput ? port.left : undefined
        anchors.left: isInput ? undefined : port.right

        anchors.rightMargin: -5
        anchors.leftMargin: -5

        visible: {
            if (port.node.scale < 1) {
                return false
            }
            return !isConnected
        }

        antialiasing: true
        opacity: 0.5

        width: height

        source: {
            switch (type) {
            case Port.REMOTE:
                height = 18
                return Theme.icon.cloud_upload
            case Port.GIMAGE:
                height = 22
                return Theme.icon.image
            case Port.GDATA:
                height = 22
                return Theme.icon.data
            default:
                return ""
            }
        }
    }

    ColorOverlay {
        anchors.fill: dataTypeIcon
        source: dataTypeIcon
        color: Theme.onbackground
        opacity: dataTypeIcon.opacity
        visible: dataTypeIcon.visible
    }
}
