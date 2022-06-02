import QtQuick 2.0

import Backend 1.0
import Global 1.0

import "node"

Item {
    id: nodeCreator

    function getNodeNumber(className) {
        let num = 0
        let nodes = canvas.nodes
        nodes.forEach(function (node) {
            if (className === node.className) {
                if (num < node.number) {
                    num = node.number
                }
            }
        })
        num++
        return num
    }

    function createNode(name) {
        let custom = "qrc:/node/custom/" + name + ".qml"
        var comp = Qt.createComponent(custom)

        let node
        if (comp.status === Component.Ready) {
            node = comp.createObject(root)
        } else {
            let auto = _createNodeQmlString(name)
            node = Qt.createQmlObject(auto, root)
        }

        node.className = name
        node.number = getNodeNumber(name)

        let creationMessage = node.model.getCreationMessage()
        if (creationMessage !== "") {
            node.printUserMessage(qsTr(creationMessage))
        }
        return node
    }

    function _createNodeQmlString(name) {
        let imports = 'import QtQuick 2.15\n' + 'import Model.' + name
            + ' 1.0\n' + 'import "node/"\n'
        let node = 'GNode { model: ' + name + 'Model {} }\n'

        return imports + node
    }
}
