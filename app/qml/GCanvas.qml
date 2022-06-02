import QtQuick 2.15

import QtQuick.Controls 2.15

import Theme 1.0
import Global 1.0
import Backend 1.0

import "components/"

Canvas {
    id: canvas

    focus: true

    signal minimumSizeChanged

    signal nodeAdded(var node)
    signal nodeRemoved(var node)

    signal edgeAdded(var edge)
    signal edgeRemoved(var edge)

    property int minimumWidth: 0
    property int minimumHeight: 0

    property var nodes: []
    property var selectedNodes: []
    property var edges: []

    property int nodeLayer: 0

    readonly property double gridSize: 30
    readonly property color gridColor: Theme.onbackground
    readonly property color backgroundColor: Theme.background
    readonly property color hoverColor: Theme.secondary
    readonly property color edgeColor: Theme.darkMode ? Theme.primaryLight : Theme.primaryDark
    readonly property color strokeColor: Theme.onbackground

    property alias mouseArea: mouseArea

    property int hoveredEdge: -1

    property int edgeFromX: 0
    property int edgeFromY: 0
    property int edgeToX: 0
    property int edgeToY: 0

    property double mx: 0
    property double my: 0
    property double lastx: 0.0
    property double lasty: 0.0

    property bool drawing: false

    property var hoveredFromPort: null
    property var hoveredToPort: null

    property bool toPortHovered: false

    property var hoveredView: null

    property int minimumX: 0

    property bool isControlKeyPressed: false

    property Action cutSelectedNodesAction: Action {
        text: qsTr("Cut")
        shortcut: "Ctrl+X"
        onTriggered: {
            copySelectedNodesAction.trigger()
            removeSelectedNodesAction.trigger()
        }
        enabled: removeSelectedNodesAction.enabled
    }

    property Action copySelectedNodesAction: Action {
        property var copiedData: []
        property bool hasCopiedData: false
        text: qsTr("Copy")
        shortcut: "Ctrl+C"
        onTriggered: {
            copiedData = {
                "nodes": getNodesSaveData(selectedNodes),
                "edges": getEdgesSaveData(selectedNodes)
            }
            hasCopiedData = true
        }
        enabled: selectedNodes.length > 0
    }

    property Action pasteSelectedNodesAction: Action {
        text: qsTr("Paste")
        shortcut: "Ctrl+V"
        onTriggered: {
            resetSelectedNodes()
            let nodesData = copySelectedNodesAction.copiedData["nodes"]
            let edgesData = copySelectedNodesAction.copiedData["edges"]

            nodesData.forEach(function (data) {
                data["x"] += 10
                data["y"] += 10
            })

            let pastedNodes = loadNodes(nodesData)
            loadEdges(edgesData, pastedNodes)
            pastedNodes.forEach(function (node) {
                node.setSelected(true)
            })
        }
        enabled: copySelectedNodesAction.hasCopiedData
    }

    property Action duplicateSelectedNodesAction: Action {
        text: qsTr("Duplicate")
        shortcut: "Ctrl+D"
        onTriggered: {
            copySelectedNodesAction.trigger()
            pasteSelectedNodesAction.trigger()
        }
        enabled: copySelectedNodesAction.enabled
    }

    property Action removeSelectedNodesAction: Action {
        text: qsTr("Remove")
        shortcut: "Del"
        onTriggered: {
            requestRemoveNodes(selectedNodes)
        }
        enabled: {
            if (selectedNodes.length > 0) {
                let counter = 0
                for (var i = 0; i < selectedNodes.length; i++) {
                    let node = selectedNodes[i]
                    if (node.hasViewConnection()) {
                        return true
                    }
                    if (node.isPartOfStream) {
                        counter++
                    }
                }
                return counter != selectedNodes.length
            }
            return false
        }
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_Control) {
            isControlKeyPressed = true
        }
    }

    Keys.onReleased: {
        if (event.key === Qt.Key_Control) {
            isControlKeyPressed = false
        }
    }

    onPaint: {
        var ctx = getContext("2d")
        ctx.reset()

        ctx.lineWidth = 2
        ctx.lineCap = "round"
        ctx.strokeStyle = edgeColor

        ctx.beginPath()
        ctx.moveTo(edgeFromX, edgeFromY)
        ctx.lineTo(edgeToX, edgeToY)
        ctx.stroke()

        for (var i = 0; i < edges.length; i++) {
            var edge = edges[i]

            if (hoveredEdge === i) {
                ctx.strokeStyle = canvas.hoverColor
            } else {
                ctx.strokeStyle = canvas.edgeColor
            }

            ctx.beginPath()

            var fromX = edge.portOut.viewPort.absCenterX
            var fromY = edge.portOut.viewPort.absCenterY

            var toX = edge.portIn.viewPort.absCenterX
            var toY = edge.portIn.viewPort.absCenterY

            ctx.moveTo(fromX, fromY)
            ctx.lineTo(toX, toY)
            ctx.stroke()
        }

        // draw the selection rectangle
        if (drawing && hoveredFromPort === null && hoveredToPort === null) {
            ctx.lineCap = "square"
            ctx.lineJoin = "round"
            ctx.lineWidth = 2
            ctx.strokeStyle = strokeColor
            ctx.clearRect(0, 0, 0, 0)
            ctx.strokeRect(lastx, lasty, mx - lastx, my - lasty)
        }
    }

    Canvas {
        id: backgroundCanvas
        z: -1
        width: parent.width
        height: parent.height

        Component.onCompleted: {
            update()
            requestPaint()
        }

        opacity: 0.2

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()

            ctx.fillStyle = backgroundColor
            ctx.fillRect(0, 0, width, height)

            for (var i = 0; i < canvas.width; i += gridSize) {
                ctx.moveTo(i, 0)
                ctx.lineTo(i, canvas.height)
            }
            for (i = 0; i < canvas.height; i += gridSize) {
                ctx.moveTo(0, i)
                ctx.lineTo(canvas.width, i)
            }
            ctx.lineWidth = 1
            ctx.lineCap = "round"
            ctx.strokeStyle = gridColor
            ctx.stroke()
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        acceptedButtons: Qt.LeftButton | Qt.RightButton

        readonly property int _left: 0
        readonly property int _center: 1
        readonly property int _right: 2

        property int hoveredEdgeArea: _left // 0 = left, 1 = center, 2 = right

        property bool openMenu: false

        GMenu {
            id: portMenu
            property var port: null
            property var node: null
            GMenuItem {
                text: qsTr("Disconnect View")
                action: portMenu.port ? portMenu.port.connectedView ? portMenu.port.connectedView.disconnectPortAction : null : null
                enabled: action ? action.enabled : portMenu.port
                                  && portMenu.port.connectedView
            }
            GMenuItem {
                text: action ? action.text : qsTr("Save Image As")
                action: portMenu.port ? portMenu.port.connectedView ? portMenu.port.connectedView.task ? portMenu.port.connectedView.task.saveImageAction : null : null : null
                enabled: action ? action.enabled : false
            }
            GMenuItem {
                text: action ? action.text : qsTr("Save Video As")
                action: portMenu.port ? portMenu.port.connectedView ? portMenu.port.connectedView.task ? portMenu.port.connectedView.task.saveVideoAction : null : null : null
                enabled: action ? action.enabled : false
            }
        }

        GMenu {
            id: canvasMenu

            GMenuItem {
                action: cutSelectedNodesAction
            }

            GMenuItem {
                action: copySelectedNodesAction
            }

            GMenuItem {
                action: pasteSelectedNodesAction
            }

            GMenuItem {
                action: duplicateSelectedNodesAction
            }

            GMenuItem {
                action: removeSelectedNodesAction
            }
        }

        onPressed: {
            forceActiveFocus()

            if (hoveredFromPort == null && hoveredToPort == null
                    && hoveredEdge === -1) {
                canvas.lastx = mouse.x
                canvas.lasty = mouse.y
                canvas.drawing = true
            }

            if (mouse.button === Qt.RightButton) {
                openMenu = true
                return
            }

            if (canvas.hoveredEdge >= 0 && hoveredEdgeArea != _center) {

                var otherPort
                if (hoveredEdgeArea == _left) {
                    hoveredFromPort = canvas.edges[canvas.hoveredEdge].portIn
                    otherPort = canvas.edges[canvas.hoveredEdge].portOut
                } else {
                    hoveredFromPort = canvas.edges[canvas.hoveredEdge].portOut
                    otherPort = canvas.edges[canvas.hoveredEdge].portIn
                }
                if (removeEdge(canvas.hoveredEdge)) {
                    canvas.hoveredEdge = -1
                    canvas.update()
                    canvas.requestPaint()
                }

                positionChanged(mouse)
            }
        }

        onReleased: {
            if (mouse.button == Qt.LeftButton) {
                resetSelectedNodes()
            }
            if (openMenu) {
                if (canvas.hoveredFromPort !== null
                        && !canvas.hoveredFromPort.isInput) {
                    portMenu.port = canvas.hoveredFromPort
                    portMenu.node = canvas.hoveredFromPort.node
                    portMenu.popup()
                } else {
                    canvasMenu.popup()
                }
                openMenu = false
            }

            if (canvas.lastx === mouse.x && canvas.lasty === mouse.y) {
                drawing = false
            }

            if (hoveredFromPort == null && hoveredToPort == null
                    && hoveredEdge === -1 && drawing === true) {
                canvas.requestPaint()
                canvas.drawing = false
                selectNodesInRectangle()
            }

            if (hoveredFromPort) {

                canvas.edgeFromX = 0
                canvas.edgeFromY = 0
                canvas.edgeToX = 0
                canvas.edgeToY = 0

                if (hoveredToPort && isEdgeAllowed(hoveredToPort)) {
                    // draw Edge
                    canvas.addEdge(retrieveEdge(hoveredToPort))
                    hoveredToPort = null
                } else {
                    if (hoveredView) {
                        // connect view
                        hoveredView.connectPort(hoveredFromPort)
                    }
                    canvas.update()
                    canvas.requestPaint()
                }
                hoveredView = null
                hoveredFromPort = null
                hoveredToPort = null
            } else if (canvas.hoveredEdge >= 0 && hoveredEdgeArea == _center) {
                if (removeEdge(canvas.hoveredEdge)) {
                    canvas.hoveredEdge = -1
                    canvas.update()
                    canvas.requestPaint()
                }
            }
        }

        onExited: {
            if (hoveredFromPort != null) {
                if (!pressed) {
                    hoveredFromPort = null
                }
            }
        }

        onPositionChanged: {
            if (hoveredFromPort == null && hoveredToPort == null) {
                canvas.mx = mouse.x
                canvas.my = mouse.y
                if (canvas.drawing)
                    canvas.requestPaint()
            }

            var i

            if (!pressed) {
                // consider hover ports
                var hoveredPort = null

                nodesLoop: for (i = 0; i < canvas.nodes.length; i++) {
                    var node = canvas.nodes[i]
                    for (var j = 0; j < node.inPorts.length; j++) {
                        if (node.inPorts[j].isHovered) {
                            hoveredPort = node.inPorts[j]
                            break nodesLoop
                        }
                    }
                    for (var k = 0; k < node.outPorts.length; k++) {
                        if (node.outPorts[k].isHovered) {
                            hoveredPort = node.outPorts[k]
                            break nodesLoop
                        }
                    }
                }

                if (hoveredFromPort !== hoveredPort) {
                    hoveredFromPort = hoveredPort
                }

                if (hoveredPort !== null) {

                    if (canvas.hoveredEdge >= 0) {

                        var edgePort = canvas.edges[canvas.hoveredEdge].portOut

                        edgePort = canvas.edges[canvas.hoveredEdge].portIn

                        canvas.hoveredEdge = -1

                        canvas.update()
                        canvas.requestPaint()
                    }

                    return
                }

                // consider hover edges
                var updateNeeded = false
                var hovered = false

                for (i = 0; i < canvas.edges.length; i++) {
                    var edge = canvas.edges[i]

                    var fromX = edge.portOut.viewPort.absCenterX
                    var fromY = edge.portOut.viewPort.absCenterY
                    var toX = edge.portIn.viewPort.absCenterX
                    var toY = edge.portIn.viewPort.absCenterY

                    if (!inRect(fromX, toX, fromY, toY)) {
                        continue
                    }

                    var a = (toY - fromY) / (toX - fromX)
                    var t = toY - a * toX

                    var y = a * mouseX + t
                    var x

                    if (toX !== fromX) {
                        x = (mouseY - t) / a
                    } else {
                        x = toX
                    }

                    var midFromX = fromX + (toX - fromX) / 3
                    var midToX = toX - (toX - fromX) / 3
                    var midFromY = fromY + (toY - fromY) / 3
                    var midToY = toY - (toY - fromY) / 3

                    var yDelta = Math.abs(y - mouseY)
                    var xDelta = Math.abs(x - mouseX)

                    if (yDelta < 5 || xDelta < 5) {

                        hovered = true

                        if (canvas.hoveredEdge !== i) {
                            canvas.hoveredEdge = i
                            updateNeeded = true
                        }

                        if (inRect(fromX, midFromX, fromY, midFromY)) {
                            // left
                            hoveredEdgeArea = _left
                        } else if (inRect(midToX, toX, midToY, toY)) {
                            // right
                            hoveredEdgeArea = _right
                        } else {
                            // center
                            hoveredEdgeArea = _center
                        }
                        break
                    }
                }

                if (!hovered && canvas.hoveredEdge >= 0) {
                    canvas.hoveredEdge = -1
                    updateNeeded = true
                }

                if (updateNeeded) {
                    canvas.update()
                    canvas.requestPaint()
                }
            } else {
                if (pressedButtons & Qt.RightButton) {
                    return
                }

                // pressed
                if (hoveredFromPort != null) {

                    toPortHovered = false
                    var fromNode = hoveredFromPort.parent
                    var fromPort = hoveredFromPort

                    if (!fromPort.isInput && fromPort.type !== Port.REMOTE) {
                        let pos = mapToItem(root.background, mouse.x, mouse.y)
                        hoveredView = viewArea.retrieveHoveredView(pos.x, pos.y)
                    }

                    canvas.edgeFromX = fromPort.viewPort.absCenterX
                    canvas.edgeFromY = fromPort.viewPort.absCenterY
                    canvas.edgeToX = mouseX
                    canvas.edgeToY = mouseY

                    for (i = 0; i < canvas.nodes.length; i++) {
                        let toNode = canvas.nodes[i]
                        if (toNode !== fromNode) {
                            let toPort
                            if (fromPort.isInput) {
                                for (var m = 0; m < toNode.outPorts.length; m++) {
                                    toPort = toNode.outPorts[m]
                                    if (drawEdge(toPort, toNode)) {
                                        break
                                    }
                                }
                            } else {
                                for (var n = 0; n < toNode.inPorts.length; n++) {
                                    toPort = toNode.inPorts[n]
                                    if (drawEdge(toPort, toNode)) {
                                        break
                                    }
                                }
                            }
                        }
                    }

                    canvas.requestPaint()
                    canvas.update()
                    if (!toPortHovered && hoveredToPort != null) {
                        hoveredToPort = null
                    }
                    canvas.update()
                    canvas.requestPaint()
                }
            }
        }

        function retrieveEdge(toPort) {
            var fromPort = hoveredFromPort

            var portIn
            var portOut

            if (fromPort.isInput) {
                portIn = fromPort
                portOut = toPort
            } else {
                portIn = toPort
                portOut = fromPort
            }

            return {
                "portIn": portIn,
                "portOut": portOut
            }
        }

        function inRect(fromX, toX, fromY, toY) {
            if (mouseX < Math.min(fromX,
                                  toX) || mouseY < Math.min(fromY,
                                                            toY) || mouseX
                    > Math.max(fromX, toX) || mouseY > Math.max(fromY, toY)) {
                return false
            } else {
                return mouseArea.containsMouse
            }
        }

        function inRect2(x, y, height, width) {
            return inRect(x, x + width, y, y + height)
        }
    }

    function addNode(node) {
        nodes.push(node)

        node.parent = canvas

        positionNode(node, true)

        node.removed.connect(internal.removeNode)
        nodeAdded(node)
    }

    function positionNode(node, normalizeToCanvas) {
        if (normalizeToCanvas) {
            let pos = mapToItem(root.background, canvas.x, canvas.y)
            node.x -= pos.x
            node.y -= pos.y
        }

        node.x = Math.max(0, node.x)
        node.x = Math.min(canvas.width - node.width, node.x)
        node.y = Math.max(0, node.y)
        node.y = Math.min(canvas.height - node.height, node.y)

        bringToFront(node)

        calculateMinimumSize()
    }

    function requestRemoveNodes(requestedNodes) {
        let nodesToHandleRemove = []
        let nodesToRemove = []
        internal.requestedNodes = []
        internal.removeHandledCounter = 0

        requestedNodes.forEach(node => {
                                   if (node.hasViewConnection()) {
                                       nodesToHandleRemove.push(node)
                                   } else {
                                       nodesToRemove.push(node)
                                   }
                                   internal.requestedNodes.push(node)
                               })

        if (nodesToHandleRemove.length > 0) {
            internal.removeNodesAfterHandling = true
            internal.handleRemoveCount = nodesToHandleRemove.length
            nodesToHandleRemove.forEach(node => {
                                            node.disconnectViews(() => {
                                                                     internal.removeHandledCounter++
                                                                 })
                                        })
        } else {
            while (nodesToRemove.length > 0) {
                let node = nodesToRemove[0]
                nodesToRemove.splice(0, 1)
                node.removeAction.trigger()
            }
        }
    }

    function isEdgeAllowed(toPort) {

        var curEdge = mouseArea.retrieveEdge(toPort)

        if (curEdge.portIn !== toPort && curEdge.portIn !== undefined) {
            toPort = curEdge.portIn
        } else {

        }

        if (toPort.isConnected === true) {
            return false
        } else {
            // restrict connection to port with different type
            if (toPort.type !== curEdge.portOut.type) {
                if (toPort.type !== -1 && curEdge.portOut.type !== -1) {
                    return false
                }
            }
            // check if after adding this edge a cycle would be created
            var val = curEdge.portOut.node.model.hasGraphCircle(
                        toPort.node.model)
            return !val
        }
    }

    function addEdge(edge) {
        edge.portIn.node.model.addInNode(edge.portOut.node.model,
                                         edge.portOut.position,
                                         edge.portIn.position)
        edge.portOut.node.model.addOutNode(edge.portIn.node.model)

        edge.portOut.hasEdge = true
        edge.portIn.isConnected = true

        edges.push(edge)
        edgeAdded(edge)
    }

    function removeEdge(index) {
        var tmp = edges[index]

        if (tmp.portIn.node.isLocked || tmp.portIn.node.isPartOfStream) {
            console.debug("Cannot remove Edge: Node locked!")
            Global.printUserMessage(
                        "This edge can't be removed right now, as it is needed by a Task!")
            return false
        }

        var edge = edges.splice(index, 1)[0]

        let hasEdge = false
        for (var i = 0; i < edges.length; i++) {
            let e = edges[i]
            if (e.portOut === edge.portOut) {
                hasEdge = true
                break
            }
        }

        edge.portOut.hasEdge = hasEdge
        edge.portIn.isConnected = false

        edge.portIn.node.model.removeInNode(edge.portOut.node.model,
                                            edge.portIn.position)
        edge.portOut.node.model.removeOutNode(edge.portIn.node.model)

        edgeRemoved(edge)
        return true
    }

    function drawEdge(toPort, toNode) {
        if (toPort.isHovered && isEdgeAllowed(toPort)) {

            toPort.edgeAllowed = true

            hoveredToPort = toPort
            toPortHovered = true

            canvas.edgeToX = toPort.viewPort.absCenterX
            canvas.edgeToY = toPort.viewPort.absCenterY

            canvas.update()
            canvas.requestPaint()

            return true
        }

        toPort.edgeAllowed = false
        return false
    }

    function resetHoveredEdge() {
        hoveredEdge = -1
        requestPaint()
    }

    function resetSelectedNodes() {
        while (selectedNodes.length > 0) {
            selectedNodes[0].setSelected(false)
        }
        selectedNodesChanged()
    }

    function isInRectangle(node) {
        var nodeRect = node.getBodyBackgroundRect()
        var selectionRect
        if (mx < lastx) {
            // drawn from right to left
            if (my < lasty) {
                // drawn from bottom
                selectionRect = Qt.rect(mx, my, lastx - mx, lasty - my)
            } else {
                // drawn from top
                selectionRect = Qt.rect(mx, lasty, lastx - mx, my - lasty)
            }
        } else {
            // drawn from left to right
            if (my < lasty) {
                // drawn from bottom
                selectionRect = Qt.rect(lastx, my, mx - lastx, lasty - my)
            } else {
                // drawn from top
                selectionRect = Qt.rect(lastx, lasty, mx - lastx, my - lasty)
            }
        }

        return utility.intersects(nodeRect, selectionRect)
    }

    function selectNodesInRectangle() {
        for (var i = 0; i < nodes.length; i++) {
            var node = canvas.nodes[i]
            if (isInRectangle(node)) {
                node.setSelected(true)
            }
        }
    }

    function swap(a, x, y) {
        if (a.length === 1)
            return a
        a.splice(y, 1, a.splice(x, 1, a[y])[0])
        return a
    }

    function calculateMinimumSize() {
        if (nodes.length > 0) {
            let sampleNode = nodes[0]
            let maxNodeX = sampleNode.x + sampleNode.width
            let maxNodeY = sampleNode.y + sampleNode.height

            let minNodeX = sampleNode.x
            let minNodeY = sampleNode.y

            for (var i = 1; i < nodes.length; i++) {
                let node = canvas.nodes[i]
                if (node.x + node.width > maxNodeX) {
                    maxNodeX = node.x + node.width
                }
                if (node.y + node.height > maxNodeY) {
                    maxNodeY = node.y + node.height
                }
                if (node.x > minNodeX) {
                    minNodeX = node.x
                }
                if (node.y > minNodeY) {
                    minNodeY = node.y
                }
            }
            minimumWidth = maxNodeX
            minimumHeight = maxNodeY
        } else {
            minimumWidth = 0
            minimumHeight = 0
        }
        minimumSizeChanged()
    }

    function bringToFront(node) {
        nodeLayer += 1
        node.z = nodeLayer
    }

    function getNode(model) {
        let foundNode = null
        nodes.every(node => {
                        if (node.model === model) {
                            foundNode = node
                            return false
                        }
                        return true
                    })
        return foundNode
    }

    function getNodesSaveData(nodes) {
        let nodesData = []
        nodes.forEach(function (node) {
            let nodeData = node.save()
            nodesData.push(nodeData)
        })
        return nodesData
    }

    function loadNodes(nodesData) {
        let createdNodes = []
        nodesData.forEach(function (nodeData) {
            let node = nodeCreator.createNode(nodeData.className)
            addNode(node)
            node.load(nodeData)

            createdNodes.push(node)
        })
        return createdNodes
    }

    function getEdgesSaveData(nodes) {
        let edgesData = []
        edges.forEach(function (edge) {
            let outNodeIndex = nodes.indexOf(edge.portOut.node)
            let inNodeIndex = nodes.indexOf(edge.portIn.node)
            if (outNodeIndex >= 0 && inNodeIndex >= 0) {
                var edgeSaveData = {
                    "outNodeIndex": nodes.indexOf(edge.portOut.node),
                    "inNodeIndex": nodes.indexOf(edge.portIn.node),
                    "portInPosition": edge.portIn.position,
                    "portOutPosition": edge.portOut.position
                }
                edgesData.push(edgeSaveData)
            }
        })
        return edgesData
    }

    function loadEdges(edgesData, nodes) {
        edgesData.forEach(function (edgeData) {
            let inNode = nodes[edgeData["inNodeIndex"]]
            let outNode = nodes[edgeData["outNodeIndex"]]
            let portIn = inNode.inPorts[edgeData["portInPosition"]]
            let portOut = outNode.outPorts[edgeData["portOutPosition"]]
            addEdge({
                        "portIn": portIn,
                        "portOut": portOut
                    })
        })
        update()
        requestPaint()
    }

    function save() {
        return {
            "nodes": getNodesSaveData(nodes),
            "edges": getEdgesSaveData(nodes)
        }
    }

    function load(loadData) {
        let nodes = loadNodes(loadData["nodes"])
        loadEdges(loadData["edges"], nodes)
    }

    function requestClear(callback) {
        if (internal.isClearRequested) {
            // clear failed -> user requests clear again
            console.debug("canvas.requestClear(): Clear already requested!")
        }
        internal.isClearRequested = true
        internal.clearedCallback = callback
        requestRemoveNodes(nodes)
        if (nodes.length == 0) {
            internal.cleared()
        }
    }

    Connections {
        target: Global
        function onSavingVideo() {
            if (internal.removeNodesAfterHandling) {
                internal.removeNodesAfterHandling = false
            }
        }
        function onNodeDisconnectViewFailed(node) {
            internal.isClearRequested = false
        }
    }

    Connections {
        target: Global.themeSettings
        function onDarkModeEnabledChanged() {
            canvas.requestPaint()
            backgroundCanvas.requestPaint()
        }
    }

    QtObject {
        id: internal

        property bool isClearRequested: false
        property var clearedCallback: null

        property var requestedNodes: []
        property int handleRemoveCount: 0
        property int removeHandledCounter: 0
        property bool removeNodesAfterHandling: false

        onRemoveHandledCounterChanged: {
            if (!handleRemoveCount || !removeHandledCounter) {
                return
            }
            if (removeHandledCounter == handleRemoveCount) {
                if (removeNodesAfterHandling) {
                    requestRemoveNodes(requestedNodes)
                    removeNodesAfterHandling = false
                }
                if (isClearRequested) {
                    cleared()
                }
                removeHandledCounter = 0
                handleRemoveCount = 0
            }
        }

        function removeNode(node) {
            let index = nodes.indexOf(node)
            nodes.splice(index, 1)

            let edgeFound = false
            for (var i = 0; i < edges.length; i++) {
                let edge = edges[i]

                if (edge.portOut.node === node) {
                    removeEdge(i)
                    i--
                    edgeFound = true
                } else if (edge.portIn.node === node) {
                    removeEdge(i)
                    i--
                    edgeFound = true
                }
            }

            if (edgeFound) {
                update()
                requestPaint()
            }
            calculateMinimumSize()

            nodeRemoved(node)
        }

        function cleared() {
            isClearRequested = false
            if (clearedCallback) {
                clearedCallback()
                clearedCallback = null
            }
        }
    }
}
