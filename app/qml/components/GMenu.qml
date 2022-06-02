import QtQuick 2.15
import QtQuick.Controls 2.15

import Theme 1.0

Menu {
    id: menu

    background: Rectangle {
        id: bgRect
        color: Theme.surface
        implicitWidth: 200
        implicitHeight: 25

        layer.enabled: true
        layer.effect: GDropShadow {
            target: bgRect
        }
    }
}
