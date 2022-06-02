import QtQuick 2.0
import QtQuick.Controls 2.15

import Theme 1.0

MenuBarItem {
    id: menuBarItem

    property int backgroundHeight: 10
    property int backgroundWidth: 60

    contentItem: Text {
        id: text

        text: menuBarItem.text
        font: Theme.font.caption

        opacity: enabled ? Theme.opacity.normal : Theme.opacity.disabled
        color: Theme.onsurface

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: backgroundWidth
        implicitHeight: backgroundHeight

        color: Theme.surface

        Rectangle {
            color: Theme.accentEnabled ? Theme.primary : Theme.darkMode ? Qt.darker(Theme.onsurface) : Qt.lighter(Theme.onsurface)
            width: parent.width
            height: 1
            anchors.bottom: parent.bottom
        }

        Rectangle {
            id: overlay
            anchors.fill: parent
            color: text.color
            opacity: highlighted ? Theme.opacity.hover : 0.0
        }
    }
}
