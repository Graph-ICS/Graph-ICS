import QtQuick 2.15

import QtQuick.Controls 2.15

import Theme 1.0

Button {
    id: control

    property alias toolTip: toolTip

    property color highlightColor: Theme.primary
    property alias highlightAnimation: highlightAnimation

    property bool transparent: false

    signal highlightFinished

    text: "Button"

    hoverEnabled: true

    contentItem: Text {
        id: text
        text: control.text

        opacity: control.enabled ? Theme.opacity.normal : Theme.opacity.disabled
        color: Theme.onsurface
        font: Theme.font.button

        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        property alias customBorder: customBorder

        implicitWidth: 100
        implicitHeight: 42

        opacity: control.enabled ? Theme.opacity.normal : Theme.opacity.disabled
        color: transparent ? "transparent" : Theme.surface
        visible: highlightAnimation.running || !transparent

        Rectangle {
            id: customBorder
            anchors.fill: parent
            color: "transparent"
            opacity: 0
            border.color: highlightColor
            border.width: 3
        }

        Rectangle {
            id: overlay
            anchors.fill: parent
            color: text.color
            opacity: control.pressed ? Theme.opacity.pressed : control.hovered ? Theme.opacity.hover : 0.0
        }
    }

    GToolTip {
        id: toolTip
    }

    SequentialAnimation {
        id: highlightAnimation
        PropertyAnimation {
            target: control.background.customBorder
            property: "opacity"
            from: 0
            to: 1
            duration: 400
        }
        PropertyAnimation {
            target: control.background.customBorder
            property: "opacity"
            from: 1
            to: 0
            duration: 400
        }

        onFinished: {
            highlightFinished()
        }
    }
}
