import QtQuick 2.15

import QtQuick.Controls 2.15

import Theme 1.0

SplitView {
    enum Size {
        Handle = 4
    }

    property int handleSize: GSplitView.Size.Handle

    handle: Rectangle {
        property bool isHovered: false
        property bool isPressed: false

        implicitHeight: handleSize
        implicitWidth: handleSize
        color: Theme.background

        SplitHandle.onHoveredChanged: {
            isHovered = SplitHandle.hovered
        }

        SplitHandle.onPressedChanged: {
            isPressed = SplitHandle.pressed
        }

        Rectangle {
            id: handleRect

            width: parent.width == handleSize ? 1 : parent.width
            height: parent.height == handleSize ? 1 : parent.height
            color: {
                if (Theme.accentEnabled) {
                    return Theme.primary
                } else {
                    return Theme.background
                }
            }
        }
        Rectangle {
            id: overlay
            color: handleRect.color
            opacity: isPressed ? Theme.opacity.pressed : isHovered ? Theme.opacity.hover : 0.0
        }
    }
}
