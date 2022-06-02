import QtQuick 2.0
import QtQuick.Layouts 1.15

import Theme 1.0

ColumnLayout {
    id: portsColumn

    property int portCount: 0
    property int absX: x
    property int absY: y

    property var ports: []

    enum PORT {
        SPACING = 4,
        PADDING = 5,
        SIZE = 24
    }

    readonly property int portSpacing: GPortsColumn.PORT.SPACING
    readonly property int portPadding: GPortsColumn.PORT.PADDING
    readonly property int portSize: GPortsColumn.PORT.SIZE
    readonly property int minimumHeight: portCount * portSize + (spacing * portCount)

    spacing: portSpacing
    visible: portCount > 0

    function addPorts(node, isInput) {
        spacerComponent.createObject(portsColumn)
        for (var i = 0; i < portCount; i++) {
            let port = portComponent.createObject(portsColumn, {
                                                      "node": node,
                                                      "isInput": isInput,
                                                      "position": i
                                                  })
            ports.push(port)
        }
        spacerComponent.createObject(portsColumn)
    }

    Component {
        id: portComponent
        GPort {
            Layout.preferredHeight: portSize
            Layout.preferredWidth: portSize
        }
    }

    Component {
        id: spacerComponent
        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }
}
