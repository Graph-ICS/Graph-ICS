import QtQuick 2.15
import QtQuick.Controls 2.15

import Theme 1.0

MenuItem {
    id: menuItem

    property int backgroundHeight: 25
    property int backgroundWidth: 164

    arrow: Canvas {
        x: parent.width - width
        implicitWidth: backgroundHeight
        implicitHeight: backgroundHeight
        visible: menuItem.subMenu
        opacity: menuItem.enabled ? Theme.opacity.normal : Theme.opacity.disabled
        onPaint: {
            var ctx = getContext("2d")
            ctx.fillStyle = Theme.onsurface
            ctx.moveTo(5, 8)
            ctx.lineTo(width / 2, height / 2)
            ctx.lineTo(5, height - 8)
            ctx.closePath()
            ctx.fill()
        }
    }

    contentItem: Item {
        anchors.fill: parent
        Text {
            id: menuItemText
            height: parent.height
            width: parent.width - shortcutText.width
            leftPadding: Theme.smallSpacing

            text: menuItem.text

            font: Theme.font.caption
            color: Theme.onsurface
            opacity: menuItem.enabled ? Theme.opacity.normal : Theme.opacity.disabled
            antialiasing: true

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
        Text {
            id: shortcutText
            anchors.left: menuItemText.right

            height: parent.height
            rightPadding: Theme.smallSpacing

            text: action ? action.shortcut ? action.shortcut : "" : ""

            font: menuItemText.font
            color: menuItemText.color
            opacity: menuItem.enabled ? Theme.opacity.normal : Theme.opacity.disabled
            antialiasing: true

            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
        Rectangle {
            id: overlay
            anchors.fill: parent
            color: menuItemText.color
            opacity: menuItem.highlighted ? Theme.opacity.hover : 0.0
        }
    }

    background: Rectangle {
        implicitWidth: backgroundWidth
        implicitHeight: backgroundHeight
        color: Theme.surface
        opacity: menuItem.enabled ? Theme.opacity.normal : Theme.opacity.disabled
    }
}
