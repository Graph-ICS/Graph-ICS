import QtQuick 2.15
import QtQuick.Controls 2.15

import Theme 1.0

ScrollBar {
    id: control

    width: 10
    height: 10
    policy: ScrollBar.AsNeeded

    onActiveChanged: {
        if (control.policy == ScrollBar.AsNeeded) {
            if (active) {
                fadeAnimation.fadeIn = true
                fadeAnimation.restart()
            } else {
                fadeAnimation.fadeIn = false
                fadeAnimation.restart()
            }
        }
    }

    contentItem: Rectangle {
        id: handle
        property double defaultOpacity: {
            if (control.pressed) {
                return 0.4
            }
            if (control.hovered) {
                return 0.35
            }
            return 0.3
        }

        implicitWidth: control.width
        implicitHeight: control.height
        opacity: {
            if (control.policy == ScrollBar.AlwaysOn) {
                return defaultOpacity
            }
            return 0
        }
        color: Theme.onsurface

        PropertyAnimation {
            id: fadeAnimation
            property bool fadeIn: false
            target: handle
            property: "opacity"
            from: handle.opacity
            to: fadeIn ? handle.defaultOpacity : 0
            duration: fadeIn ? 20 : 800
            easing.type: fadeIn ? Easing.Linear : Easing.InExpo
        }
    }
}
