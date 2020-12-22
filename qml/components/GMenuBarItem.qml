import QtQuick 2.0
import QtQuick.Controls 2.15 as QQC2

import Theme 1.0

// Custom MenubarItem

QQC2.MenuBarItem {
    id: menuBarItem

    property int backgroundHeight: 10
    property int backgroundWidth: 40

    property color textColor: Theme.contentDelegate.color.text.normal
    property color textHoverColor: Theme.contentDelegate.color.text.hover
    property color backgroundHoverColor: Theme.contentDelegate.color.background.hover

    contentItem: Text {
        id:menuBarItemText
        text: menuBarItem.text
        font.family: Theme.font.family
        font.pointSize: Theme.font.pointSize

        font.bold: false

        opacity: enabled ? 1.0 : 0.3
        color: menuBarItem.highlighted ? textHoverColor : textColor
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        opacity: enabled ? 1.0 : 0.3
        implicitWidth: backgroundWidth
        implicitHeight: backgroundHeight
        color: menuBarItem.highlighted ? backgroundHoverColor : "transparent"
    }
}




