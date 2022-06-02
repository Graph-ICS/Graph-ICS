import QtQuick 2.15
import QtQuick.Controls 2.15
import Theme 1.0

TabButton {
    id: control

    property bool selected: false
    property bool closeable: false
    signal close

    font: Theme.font.button

    width: closeable ? text.implicitWidth + closeButton.width : text.implicitWidth
    height: parent ? parent.height : 0

    contentItem: Item {
        anchors.fill: parent

        Text {
            id: text

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: closeable ? closeButton.left : parent.right

            leftPadding: Theme.largeSpacing
            rightPadding: closeable ? Theme.smallSpacing * 2 : Theme.largeSpacing

            text: control.text

            color: Theme.onsurface
            opacity: control.enabled ? Theme.opacity.normal : Theme.opacity.disabled
            font: control.font
            antialiasing: true

            verticalAlignment: Text.AlignVCenter
        }
        GIconButton {
            id: closeButton

            visible: closeable

            anchors.right: parent.right
            anchors.rightMargin: Theme.smallSpacing
            anchors.verticalCenter: parent.verticalCenter

            height: Theme.smallHeight
            width: closeable ? height : 0

            icon.source: Theme.icon.clear
            transparent: false

            onClicked: {
                control.close()
            }
        }
    }

    background: Rectangle {
        color: Theme.surface
    }

    Rectangle {
        anchors.fill: parent
        color: text.color
        opacity: selected ? Theme.opacity.pressed : hovered ? Theme.opacity.hover : 0.0
    }
}
