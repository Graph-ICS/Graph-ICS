import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import Global 1.0
import Theme 1.0
import Backend 1.0

import "../components/"
import "../task"

Item {
    id: viewContainer

    property alias nodeMenu: nodeMenu

    property var viewArea: null

    readonly property bool isFocused: viewArea.focusedView === this

    property color backgroundColor: "gray"

    readonly property bool isConnectionAllowed: !connectedPort
    readonly property bool isPortConnected: connectedPort
    property var connectedPort: null

    property var task: taskInitializer.task
    property var currentView: null

    property bool hasDisplayedValue: false

    property var disconnectPortCallback: null

    property GMenu runMenu: GMenu {
        title: qsTr("Run")
        delegate: GMenuItem {}
    }

    property Action disconnectPortAction: Action {
        text: qsTr("Disconnect")
        onTriggered: {
            task.cancelAction.trigger()
        }
        enabled: !isConnectionAllowed && task && task.cancelAction.enabled
    }

    Component.onCompleted: {
        canvas.nodes.forEach(function (node) {
            nodeMenu.addNodeToMenu(node)
        })
    }

    onHasDisplayedValueChanged: {
        if (task) {
            task.resultDisplayed = hasDisplayedValue
        }
    }

    GTaskInitializer {
        id: taskInitializer
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: Theme.surface
    }

    Rectangle {
        id: borderRect
        z: 1
        anchors.fill: parent
        color: "transparent"
        border.color: {
            if (connectedPort) {
                return backgroundColor
            }
            return Theme.darkMode ? Qt.darker(Theme.onsurface) : Qt.lighter(
                                        Theme.onsurface)
        }

        border.width: isFocused ? 3 : 1
    }

    StackLayout {
        id: viewStack

        property int emptyViewIndex: 0

        anchors.fill: parent
        currentIndex: emptyViewIndex

        GView {
            id: emptyView
        }

        GImageView {
            id: imageView

            onUpdated: {
                hasDisplayedValue = true
            }
        }

        GDiagramView {
            id: diagramView
            onUpdated: {
                hasDisplayedValue = true
            }
        }
    }

    MouseArea {
        id: dNd
        z: 1
        hoverEnabled: true
        anchors.fill: parent
        acceptedButtons: Qt.RightButton | Qt.LeftButton

        onPressed: forceActiveFocus()

        onClicked: {
            viewArea.focusedView = viewContainer
            if (mouse.button == Qt.RightButton) {
                menu.popup()
            }
        }

        onDoubleClicked: {
            if (task) {
                task.playAction.trigger()
            }
        }

        GMenu {
            id: menu
            property int addedActionsCount: 0
            property int runMenuIndex

            delegate: GMenuItem {}

            GMenu {
                id: nodeMenu
                title: qsTr("Connect")

                cascade: true
                enabled: count > 0

                delegate: GMenuItem {}

                Component {
                    id: nodeMenuComponent
                    GMenu {
                        property var node: null
                        title: node ? node.id : ""
                        cascade: true
                        delegate: GMenuItem {}
                    }
                }

                Component {
                    id: portActionComponent
                    Action {
                        property var node: null
                        property var port: null
                        text: {
                            if (port) {
                                return qsTr("Port " + port.position)
                            }
                            if (node) {
                                return node.id
                            }
                            return ""
                        }

                        enabled: {
                            if (connectedPort
                                    && !disconnectPortAction.enabled) {
                                return false
                            }

                            let view = null
                            if (node) {
                                if (connectedPort
                                        && connectedPort.node === node) {
                                    return false
                                }
                                view = node.outPorts[0].connectedView
                            }
                            if (port) {
                                if (connectedPort == port) {
                                    return false
                                }
                                view = port.connectedView
                            }
                            return view ? view.disconnectPortAction.enabled : true
                        }
                        onTriggered: {
                            nodeMenu.dismiss()
                            if (port) {
                                connectPort(port)
                            } else {
                                connectPort(node.outPorts[0])
                            }
                        }
                    }
                }

                function addNodeToMenu(node) {
                    if (node.outPorts.length > 1) {
                        var m = nodeMenuComponent.createObject(nodeMenu)
                        m.node = node
                        nodeMenu.addMenu(m)

                        for (var i = 0; i < node.outPorts.length; i++) {
                            let action = portActionComponent.createObject(m)
                            action.port = node.outPorts[i]
                            m.addAction(action)
                        }
                    } else {
                        var action = portActionComponent.createObject(nodeMenu)
                        action.node = node
                        nodeMenu.addAction(action)
                    }
                }

                function removeNodeFromMenu(node) {
                    for (var i = 0; i < count; i++) {
                        if (node.outPorts.length > 1) {
                            var menu = menuAt(i)
                            if (menu !== null) {
                                if (menu.node === node) {
                                    nodeMenu.takeMenu(i).destroy()
                                    break
                                }
                            }
                        } else {
                            var action = actionAt(i)
                            if (action !== null) {
                                if (action.node === node) {
                                    nodeMenu.takeAction(i).destroy()
                                    break
                                }
                            }
                        }
                    }
                }
            }

            GMenuItem {
                action: disconnectPortAction
            }

            GMenuItem {
                action: Action {
                    text: qsTr("Clear")
                    onTriggered: {
                        clearView()
                    }
                    enabled: hasDisplayedValue && connectedPort !== null
                }
            }

            function addActions(actions) {
                addedActionsCount += actions.length
                for (var i = 0; i < actions.length; i++) {
                    addAction(actions[i])
                }
            }

            function removeAddedActions() {
                for (var i = 0; i < addedActionsCount; i++) {
                    takeAction(count - 1)
                }
                addedActionsCount = 0
            }
        }
    }

    function connectPort(fromPort) {
        if (!fromPort) {
            console.debug("view.connectPort: port is null!")
            return
        }

        if (connectedPort === fromPort) {
            console.debug("view.connectPort: port already connected!")
            return
        }

        if (fromPort.connectedView) {
            let view = fromPort.connectedView
            let port = fromPort
            view.disconnectPortCallback = () => {
                connectPort(port)
            }
            view.disconnectPortAction.trigger()
            return
        }

        if (connectedPort) {
            let port = fromPort
            disconnectPortCallback = () => {
                connectPort(port)
            }
            disconnectPortAction.trigger()
            return
        }
        // if connectPort does not fail focusedView gets set to this view
        viewArea.focusedView = null

        switch (fromPort.type) {
        case Port.GIMAGE:
            viewStack.currentIndex = Port.GIMAGE
            currentView = imageView
            break
        case Port.GDATA:
            viewStack.currentIndex = Port.GDATA
            currentView = diagramView
            break
        default:
            currentView = null
            console.debug("Cannot connect Port: Port type unknown!")
            return
        }

        _connectPort(fromPort)

        if (!taskInitializer.init(currentView.model, connectedPort.node.id)) {
            _disconnectPort()
            return
        }

        statusBar.createTaskControl(taskInitializer.task, backgroundColor)

        taskInitializer.task.addControlActionsToMenu(runMenu)
        menu.runMenuIndex = menu.count
        menu.addMenu(runMenu)
        if (currentView == imageView) {
            menu.addActions(taskInitializer.task.fileActions)
        }
        menu.addActions(currentView.menuActions)

        configManager.configChanged()
        viewArea.focusedView = viewContainer
    }

    function clearView() {
        hasDisplayedValue = false
        if (currentView) {
            currentView.clear()
        }
    }

    function _removePortConnection() {
        if (connectedPort === null) {
            console.debug("view.removePortConnection: connectedPort is null!")
            return
        }

        statusBar.removeTaskControl(taskInitializer.task)

        taskInitializer.deinit()
        _disconnectPort()

        menu.takeMenu(menu.runMenuIndex)
        menu.removeAddedActions()

        clearView()
        currentView = null
        viewStack.currentIndex = viewStack.emptyViewIndex

        configManager.configChanged()

        if (disconnectPortCallback) {
            disconnectPortCallback()
            disconnectPortCallback = null
        }
    }

    function _connectPort(port) {
        connectedPort = port
        port.connectedView = viewContainer
        currentView.model.addInNode(port.node.model, port.position, 0)
        port.node.model.addOutNode(currentView.model)
    }

    function _disconnectPort() {
        currentView.model.removeInNode(connectedPort.node.model, 0)
        connectedPort.node.model.removeOutNode(currentView.model)
        connectedPort.connectedView = null
        connectedPort = null
    }

    Connections {
        target: task ? task : null
        ignoreUnknownSignals: true
        function onCancelled() {
            _removePortConnection()
        }

        function onCancelHandled(isHandled) {
            if (!isHandled) {
                disconnectPortCallback = null
            }
        }

        function onHandleSaveVideo() {
            disconnectPortCallback = null
        }
    }
}
