import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import Global 1.0
import Theme 1.0
import Backend 1.0

import "../components/"
import "attribute"

Item {
    id: node

    signal removed(var node)

    property var model
    property string className

    property var attributes: []

    readonly property var inPorts: inPortsColumn.ports
    readonly property var outPorts: outPortsColumn.ports

    readonly property int inPortsCount: model ? model.getInPortsCount() : 0
    readonly property int outPortsCount: model ? model.getOutPortsCount() : 0

    readonly property var attributeNames: model ? model.getAttributeNames(
                                                      ) : null

    readonly property string name: model ? model.getName() : ""
    readonly property int type: model ? model.getType() : -1

    readonly property string id: number > 1 ? name + "(" + String(
                                                  number) + ")" : name
    readonly property bool isLocked: node.model ? node.model.isLocked : false
    readonly property bool isPartOfStream: node.model ? node.model.isPartOfStream : false

    property int number: 1

    property int absX: x + parent.x
    property int absY: y + parent.y

    property bool isDistanceCalculated: false
    property int distanceX: 0
    property int distanceY: 0

    readonly property bool isHovered: mouseArea.containsMouse
                                      || mouseArea.pressed
    property bool isSelected: false

    readonly property bool portsCreated: portsToCreateCount != 0
                                         && createdPortCount == portsToCreateCount
    property int createdPortCount: 0
    property int portsToCreateCount: 0

    property var removeCallback: null
    property bool isRemoveInitialized: false

    property Action removeAction: Action {
        text: qsTr("Remove")
        enabled: isPartOfStream ? hasViewConnection() : true
        onTriggered: {
            isRemoveInitialized = true
            disconnectViews(remove)
        }
    }

    property Component background: Rectangle {
        color: Theme.primary
        radius: 8
        border.width: 3
        border.color: {
            if (isSelected) {
                return Theme.secondary
            }
            if (isHovered) {
                return Theme.secondaryLight
            }
            return Theme.primaryDark
        }
    }

    property Component content: ColumnLayout {
        id: bodyContentDefaultColumn
        spacing: Theme.smallSpacing

        Component.onCompleted: {
            addAttributes()
        }

        Text {
            Layout.fillWidth: true
            text: id
            font: Theme.font.body2
            color: Theme.onprimary

            topPadding: Theme.largeSpacing
            leftPadding: Theme.largeSpacing
            rightPadding: Theme.largeSpacing
            bottomPadding: Theme.smallSpacing
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        function addAttributes() {
            attributeNames.forEach(function (name) {
                let attributeModel = model.getAttribute(name)
                let control = attributeModel.getControl()
                let comp = null
                switch (control) {
                case Attribute.TEXTFIELD:
                    comp = textFieldAttributeComponent
                    break
                case Attribute.COMBOBOX:
                    comp = comboBoxAttributeComponent
                    break
                case Attribute.SWITCH:
                    comp = switchAttributeComponent
                    break
                default:
                    break
                }
                if (!comp) {
                    console.debug(name + " Attribute control not Found!")
                } else {
                    let attribute = comp.createObject(bodyContentDefaultColumn,
                                                      {
                                                          "node": node,
                                                          "model": attributeModel
                                                      })
                    attribute.name = name
                    attribute.Layout.leftMargin = Theme.largeSpacing
                    attribute.Layout.minimumWidth = Qt.binding(function () {
                        return attribute.width
                    })
                    attributes.push(attribute)
                }
            })
        }
    }

    property Component textFieldAttributeComponent: TextFieldAttribute {}
    property Component comboBoxAttributeComponent: ComboBoxAttribute {}
    property Component switchAttributeComponent: SwitchAttribute {}

    width: bodyRow.width - (GPortsColumn.PORT.PADDING * portsToCreateCount)
    height: bodyRow.height

    Component.onCompleted: {
        if (inPortsCount > 0) {
            portsToCreateCount++
        }
        if (outPortsCount > 0) {
            portsToCreateCount++
        }
        internal.background = background.createObject(bodyItem, {
                                                          "anchors.fill": bodyItem,
                                                          "z": -1
                                                      })
        internal.content = content.createObject(bodyItem, {
                                                    "anchors.top": bodyItem.top
                                                })
        inPortsColumn.addPorts(node, true)
        outPortsColumn.addPorts(node, false)
    }

    Component.onDestruction: {
        // call the destructor of the c++ model
        node.model.destroy()
    }

    onWidthChanged: {
        if (portsCreated) {
            canvas.calculateMinimumSize()
            canvas.update()
            canvas.requestPaint()
            mouseArea.calculateDragBounds()
        }
    }

    onHeightChanged: {
        canvas.calculateMinimumSize()
        canvas.update()
        canvas.requestPaint()
        mouseArea.calculateDragBounds()
    }

    onIsSelectedChanged: {
        let selectedNodes = canvas.selectedNodes
        if (isSelected) {
            selectedNodes.push(node)
        } else {
            let index = selectedNodes.indexOf(node)
            selectedNodes.splice(index, 1)
        }
        canvas.selectedNodesChanged()
    }

    Row {
        id: bodyRow

        anchors.left: {
            if (!inPortsCount > 0 && outPortsCount > 0) {
                return parent.left
            }
            return undefined
        }
        anchors.right: {
            if (inPortsCount > 0 && !outPortsCount > 0) {
                return parent.right
            }
            return undefined
        }
        anchors.horizontalCenter: {
            if (inPortsCount > 0 && outPortsCount > 0) {
                return parent.horizontalCenter
            }
            return undefined
        }

        width: inPortsColumn.width + bodyItem.width + outPortsColumn.width
        height: Math.max(inPortsColumn.minimumHeight, bodyItem.minimumHeight,
                         outPortsColumn.minimumHeight)

        GPortsColumn {
            id: inPortsColumn

            portCount: inPortsCount
            absX: x + bodyRow.x + node.absX
            absY: y + bodyRow.y + node.absY

            height: parent.height
            onWidthChanged: {
                createdPortCount++
            }
        }

        Item {
            id: bodyItem
            property int minimumHeight: internal.content ? internal.content.height
                                                           + Theme.largeSpacing : 0

            width: internal.content ? internal.content.width : 0
            height: parent.height
        }

        GPortsColumn {
            id: outPortsColumn

            portCount: outPortsCount
            absX: x + bodyRow.x + node.absX
            absY: y + bodyRow.y + node.absY

            height: parent.height
            onWidthChanged: {
                createdPortCount++
            }
        }
    }

    MouseArea {
        id: mouseArea

        parent: bodyItem
        anchors.fill: parent

        hoverEnabled: true

        drag.target: node
        drag.minimumX: 0
        drag.minimumY: 0
        drag.maximumX: 0
        drag.maximumY: 0

        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onPositionChanged: {
            if (pressed) {
                configManager.configChanged()
                canvas.calculateMinimumSize()
                if (isSelected) {
                    let selectedNodes = canvas.selectedNodes

                    if (!isDistanceCalculated) {
                        for (var i = 0; i < selectedNodes.length; i++) {
                            var no = selectedNodes[i]
                            no.distanceX = node.x - no.x
                            no.distanceY = node.y - no.y
                        }
                        isDistanceCalculated = true
                    }

                    for (var j = 0; j < selectedNodes.length; j++) {
                        var nodeToMove = selectedNodes[j]
                        nodeToMove.x = node.x - nodeToMove.distanceX
                        nodeToMove.y = node.y - nodeToMove.distanceY
                    }
                }
            }
        }

        onReleased: {
            isDistanceCalculated = false
        }

        onEntered: {
            canvas.resetHoveredEdge()
        }

        onClicked: {
            if (mouse.button == Qt.RightButton) {
                canvas.resetSelectedNodes()
                isSelected = true
                contextMenu.popup()
                return
            }

            if (canvas.isControlKeyPressed) {
                isSelected = !isSelected
                return
            }
            if (isSelected) {
                if (canvas.selectedNodes.length > 1) {
                    canvas.resetSelectedNodes()
                    isSelected = true
                } else {
                    isSelected = false
                }
            } else {
                canvas.resetSelectedNodes()
                isSelected = true
            }
        }

        onDoubleClicked: {
            isSelected = true
        }

        onPressed: {
            canvas.forceActiveFocus()
            canvas.calculateMinimumSize()
            canvas.bringToFront(node)
            calculateDragBounds()
        }

        GMenu {
            id: contextMenu
            GMenuItem {
                action: Action {
                    text: qsTr("Restore Default")
                    enabled: !isLocked
                    onTriggered: {
                        restoreAttributeDefaults()
                    }
                }
            }
            GMenuItem {
                action: Action {
                    text: qsTr("Add to Favorites")
                    enabled: favoritesBar.addFavoritesAllowed
                    onTriggered: {
                        favoritesBar.addToFavorites(className)
                    }
                }
            }

            GMenuItem {
                action: canvas.cutSelectedNodesAction
            }

            GMenuItem {
                action: canvas.copySelectedNodesAction
            }

            GMenuItem {
                action: canvas.duplicateSelectedNodesAction
            }

            GMenuItem {
                action: canvas.removeSelectedNodesAction
            }
        }

        function calculateDragBounds() {
            if (!node.isSelected) {
                drag.maximumX = canvas.width - node.width
                drag.minimumX = 0
                drag.maximumY = canvas.height - node.height
                drag.minimumY = 0
            } else {
                var shortestX = node.x
                var longestX = node.x + node.width

                var shortestY = node.y
                var longestY = node.y + node.height

                for (var i = 0; i < canvas.nodes.length; i++) {
                    var canvasNode = canvas.nodes[i]

                    if (canvasNode !== node) {

                        if (canvasNode.isSelected) {

                            if (shortestX > canvasNode.x) {
                                shortestX = canvasNode.x
                            }
                            if (longestX < canvasNode.x + canvasNode.width) {
                                longestX = canvasNode.x + canvasNode.width
                            }

                            if (shortestY > canvasNode.y) {
                                shortestY = canvasNode.y
                            }
                            if (longestY < canvasNode.y + canvasNode.height) {
                                longestY = canvasNode.y + canvasNode.height
                            }
                        }
                    }
                }

                if (node.x === shortestX) {
                    drag.minimumX = 0
                } else {
                    drag.minimumX = node.x - shortestX
                }

                if (longestX === node.x + node.width) {
                    drag.maximumX = canvas.width - node.width
                } else {
                    drag.maximumX = node.x + (canvas.width - longestX)
                }

                drag.minimumY = node.y - shortestY

                if (longestY === node.y + node.height) {
                    drag.maximumY = canvas.height - node.height
                } else {
                    drag.maximumY = node.y + (canvas.height - longestY)
                }
            }
        }
    }

    PropertyAnimation {
        id: createAnimation
        property bool isDrop: true
        target: node
        property: "scale"
        from: isDrop ? 0.5 : 0
        to: isDrop ? 1 : 0.5
        easing.type: isDrop ? Easing.InOutBack : Easing.Linear
        duration: isDrop ? 150 : 75
    }

    function disconnectViews(callback) {
        internal.disconnectViewsCallback = callback
        internal.disconnectViews()
    }

    function remove() {
        if (hasViewConnection()) {
            isRemoveInitialized = false
            printUserMessage("Cannot be removed right now!")
            console.debug("Cannot remove Node: Node has View connection!")
            return
        }
        isSelected = false
        removed(node)
        node.destroy()
    }

    function hasViewConnection() {
        for (var i = 0; i < outPorts.length; i++) {
            if (outPorts[i].connectedView) {
                return true
            }
        }
        return false
    }

    function setSelected(value) {
        isSelected = value
    }

    function runDropAnimation() {
        createAnimation.isDrop = true
        createAnimation.restart()
    }

    function runPickupAnimation() {
        createAnimation.isDrop = false
        createAnimation.restart()
    }

    function getBodyBackgroundRect() {
        return Qt.rect(node.x + bodyRow.x + bodyItem.x + internal.background.x,
                       node.y + bodyRow.y + bodyItem.y + internal.background.y,
                       internal.background.width, internal.background.height)
    }

    function restoreAttributeDefaults() {
        for (var i = 0; i < attributes.length; i++) {
            attributes[i].restoreDefault()
        }
    }

    function save() {
        let saveData = {
            "className": className,
            "x": x,
            "y": y
            // Removed number so copy/paste nodes could be implemented way easier
            // Config save and load -> nodes have different numbers
            //            "number": number
        }
        attributes.forEach(function (attribute) {
            saveData[attribute.name] = attribute.value
        })
        return saveData
    }

    function load(saveData) {
        className = saveData["className"]
        x = saveData["x"]
        y = saveData["y"]
        //        number = saveData["number"]
        attributes.forEach(function (attribute) {
            attribute.setValue(saveData[attribute.name])
        })
    }

    function printUserMessage(message) {
        Global.printUserMessage(id + ": " + message)
    }

    Connections {
        target: model ? model : null

        function onStatusChanged(messageCode) {
            switch (messageCode) {
            case Node.RETRIEVE_RESULT_FAILED:
                printUserMessage(qsTr("Empty result delivered!"))
                break
            case Node.IN_PORT_CONNECTION_MISSING:
                printUserMessage(qsTr("All in ports need to be connected!"))
                break
            default:
                break
            }
        }

        function onMessage(message) {
            printUserMessage(qsTr(message))
        }

        function onAttributeValueChanged(attributeModel) {
            configManager.configChanged()
        }
    }

    QtObject {
        id: internal
        property Item background
        property Item content

        property var disconnectViewsCallback: null

        function disconnectViews() {
            for (var i = 0; i < outPorts.length; i++) {
                let outPort = outPorts[i]
                let view = outPort.connectedView
                if (view) {
                    if (view.disconnectPortAction.enabled) {
                        view.disconnectPortCallback = function () {
                            view.disconnectPortCallback = null
                            internal.disconnectViews()
                        }
                        view.disconnectPortAction.trigger()
                    } else {
                        printUserMessage(
                                    "View cannot be disconnected right now!")
                        console.debug(
                                    id + ".internal.disconnectViews: View disconnect Action not enabled!")

                        Global.nodeDisconnectViewFailed(node)
                    }
                    return
                }
            }
            if (disconnectViewsCallback) {
                disconnectViewsCallback()
                disconnectViewsCallback = null
            }
        }
    }
}
