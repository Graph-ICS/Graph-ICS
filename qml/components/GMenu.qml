import QtQuick 2.0
import QtQuick.Controls 2.15 as QQC2

import Theme 1.0

// Custom Menu implementierung fuer Graph-ICS

QQC2.Menu{

    delegate: QQC2.MenuItem {
        id: menuItem

        property int backgroundHeight: 10
        property int backgroundWidth: 200

        property color textColor: Theme.contentDelegate.color.text.hover
        property color textPressColor: Theme.contentDelegate.color.text.press
        property color backgroundHoverColor: Theme.contentDelegate.color.background.press

        contentItem: Text {
            id:menuItemText
            text: menuItem.text
            font.family: Theme.font.family
            font.pointSize: Theme.font.pointSize

            font.bold: false

            opacity: enabled ? 1.0 : 0.3
            color: menuItem.highlighted ? textPressColor : textColor
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle {
            opacity: enabled ? 1.0 : 0.3
            implicitWidth: backgroundWidth
            implicitHeight: backgroundHeight
            color: menuItem.highlighted ? backgroundHoverColor : "transparent"
        }
    }

    background: Rectangle {
        color: Theme.contentDelegate.color.background.hover
        implicitWidth: 200
        implicitHeight: 10
//        border.color: Theme.menubar.menuItem.hoverColor
//        radius: 1
    }
}


