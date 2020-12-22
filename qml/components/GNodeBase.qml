import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2


import Theme 1.0
import "../"
import "../components/"


Rectangle {
    id: graphics_NodeBase

    property var colorState: QtObject {

        property var background: QtObject {
            property color normal: Theme.node.color.background.normal
            property color shown: Theme.node.color.background.shown
        }

        property var border: QtObject {
            property color normal: Qt.darker(graphics_NodeBase.color)
            property color select: Theme.node.color.border.select
            property color hover: Theme.node.color.border.hover
        }
    }

    property int minWidth: 64
    property bool isShown: false
    radius: 8

    state: 'normal'

    width: minWidth

    states: [
        State {
            name: "normal"
            PropertyChanges {
                target: graphics_NodeBase
                color: isShown ? graphics_NodeBase.colorState.background.shown : graphics_NodeBase.colorState.background.normal
                border.color: graphics_NodeBase.colorState.border.normal
                border.width: 3
            }
        },
        State {
            name: "select"
            PropertyChanges {
                target: graphics_NodeBase
                border.color: graphics_NodeBase.colorState.border.select
                color: isShown ? graphics_NodeBase.colorState.background.shown : graphics_NodeBase.colorState.background.normal
                border.width: 3
            }
        },
        State {
            name: "hover"
            PropertyChanges {
                target: graphics_NodeBase
                border.color: graphics_NodeBase.colorState.border.hover
                color: isShown ? graphics_NodeBase.colorState.background.shown : graphics_NodeBase.colorState.background.normal
                border.width: 3
            }
        }
    ]
}
