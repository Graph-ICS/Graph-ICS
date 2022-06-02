import QtQuick 2.15
import QtQuick.Controls 2.15

import Theme 1.0

ProgressBar {
    id: control

    property string innerText: ""

    padding: 4

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 6
        color: "transparent"
        radius: 4
        border.color: Theme.primary
        border.width: 2
    }

    contentItem: Item {
        implicitWidth: 200
        implicitHeight: 4

        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            radius: 1
            color: Theme.primary
        }
        Text {
            anchors.fill: parent
            text: innerText
            color: Theme.onprimary
            font: Theme.font.caption
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
        }
    }
}
