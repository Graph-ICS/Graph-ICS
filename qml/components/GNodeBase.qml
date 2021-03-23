import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2


import Theme 1.0
import "../"
import "../components/"


Rectangle {
    id: graphics_NodeBase



    property var colorState: QtObject {

        property var border: QtObject {
            property color normal: Theme.node.color.background.border
            property color select: Theme.node.color.border.select
            property color hover: Theme.node.color.border.hover
        }
    }

    property color baseColor: Theme.node.color.background.normal
    property int minWidth: 64

    radius: 8

    state: 'normal'

    width: minWidth

    states: [
        State {
            name: "normal"
            PropertyChanges {
                target: graphics_NodeBase
                color: graphics_NodeBase.baseColor
                border.color: graphics_NodeBase.colorState.border.normal
                border.width: 3
            }
        },
        State {
            name: "select"
            PropertyChanges {
                target: graphics_NodeBase
                border.color: graphics_NodeBase.colorState.border.select
                color: graphics_NodeBase.baseColor
                border.width: 3
            }
        },
        State {
            name: "hover"
            PropertyChanges {
                target: graphics_NodeBase
                border.color: graphics_NodeBase.colorState.border.hover
                color: graphics_NodeBase.baseColor
                border.width: 3
            }
        }
    ]
}
