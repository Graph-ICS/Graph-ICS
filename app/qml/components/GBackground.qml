import QtQuick 2.0

import Theme 1.0

Rectangle {
    id: background
    color: Theme.surface
    Rectangle {
        id: overlay
        anchors.fill: parent
        color: Theme.onsurface
        opacity: Theme.opacity.pressed
    }
    Rectangle {
        id: innerBackground
        anchors.fill: parent
        anchors.margins: Theme.marginWidth
        color: Theme.surface
    }
    function getMarginWidth() {
        return background.anchors.margins + innerBackground.anchors.margins + Theme.smallSpacing
    }
}
