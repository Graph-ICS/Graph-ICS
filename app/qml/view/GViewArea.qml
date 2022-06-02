import QtQuick 2.15
import QtCharts 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.12

import Theme 1.0
import Global 1.0

import "../components/"
import "."

Item {
    id: area

    property var focusedView: null

    property var views: []
    property int minWidth: gridView.columns * 24

    property Action addViewAction: Action {
        text: qsTr("Add View")
        icon.source: Theme.icon.add
        enabled: viewsModel.count < Theme.viewArea.colors.length
        onTriggered: {
            viewsModel.append({
                                  "viewColor": Theme.viewArea.colors[viewsModel.count]
                              })
            layoutViews()
        }
    }

    property Action removeViewAction: Action {
        property bool waitForCallback: false
        property var callback: function () {
            waitForCallback = false
            viewsModel.remove(viewsModel.count - 1)
            layoutViews()
        }
        text: qsTr("Remove View")
        icon.source: Theme.icon.remove
        enabled: !waitForCallback && viewsModel.count > 1
        onTriggered: {
            waitForCallback = false
            let view = gridView.itemAtIndex(viewsModel.count - 1)
            if (view.isPortConnected) {
                waitForCallback = true
                if (view.disconnectPortAction.enabled) {

                    view.disconnectPortCallback = callback
                    view.disconnectPortAction.trigger()
                }
            }
            if (!waitForCallback) {
                callback()
            }
        }
    }

    onFocusedViewChanged: {
        Global.focusedView = focusedView
    }

    Component.onCompleted: {
        for (var i = 0; i < Global.windowSettings.viewsCount; i++) {
            addViewAction.trigger()
        }
        layoutViews()
    }

    Component.onDestruction: {
        Global.windowSettings.viewsCount = viewsModel.count
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.background
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        GIconButton {
            Layout.preferredHeight: Theme.smallHeight - 6
            Layout.fillWidth: true

            backgroundColor: Theme.background

            action: addViewAction
            toolTip.text: action.text
        }
        GridView {
            id: gridView
            property int lines: 1
            property int columns: 1

            Layout.fillHeight: true
            Layout.fillWidth: true

            delegate: GViewContainer {
                width: gridView.cellWidth - 2
                height: gridView.cellHeight - 2
                backgroundColor: viewColor

                viewArea: area
            }

            model: ListModel {
                id: viewsModel
            }

            flow: GridView.FlowTopToBottom
            cellHeight: gridView.height / lines
            cellWidth: gridView.width / columns
            interactive: false
        }
        GIconButton {
            Layout.preferredHeight: Theme.smallHeight - 6
            Layout.fillWidth: true

            backgroundColor: Theme.background

            action: removeViewAction
            toolTip.text: action.text
        }
    }

    function layoutViews() {
        if (viewsModel.count % 3 == 0) {
            let div = viewsModel.count / 3
            gridView.lines = div
            gridView.columns = 3
            return
        }

        if (viewsModel.count % 2 == 0) {
            let div = viewsModel.count / 2
            gridView.columns = div
            gridView.lines = 2
            return
        }

        gridView.lines = 1
        gridView.columns = viewsModel.count
    }

    function viewAt(index) {
        return gridView.itemAtIndex(index)
    }

    function retrieveHoveredView(mouseX, mouseY) {
        var hoveredView = null
        forEachView(function (view) {
            var pos = root.getAbsolutePosition(view)
            if (mouseX > pos.x && mouseX < pos.x + view.width) {
                if (mouseY > pos.y && mouseY < pos.y + view.height) {
                    hoveredView = view
                }
            }
        })

        if (focusedView != hoveredView) {
            if (!(hoveredView && hoveredView.connectedPort
                  && !hoveredView.disconnectPortAction.enabled)) {
                focusedView = hoveredView
            } else {
                focusedView = null
            }
        }

        return focusedView
    }

    function save() {
        let saveData = {
            "viewsCount": viewsModel.count,
            "connections": []
        }
        let connections = []
        let i = 0
        forEachView(function (view) {
            i++
            if (view.connectedPort !== null) {
                connections.push({
                                     "viewIndex": i - 1,
                                     "nodeIndex": canvas.nodes.indexOf(
                                                      view.connectedPort.node),
                                     "outPortPosition": view.connectedPort.position
                                 })
            }
        })
        saveData["connections"] = connections
        return saveData
    }

    function load(loadData) {
        let viewsCount = loadData["viewsCount"]
        let currentViewsCount = viewsModel.count
        for (var i = currentViewsCount; i < viewsCount; i++) {
            addViewAction.trigger()
        }
        let connections = loadData["connections"]
        connections.forEach(function (connection) {
            let view = viewAt(connection["viewIndex"])
            let node = canvas.nodes[connection["nodeIndex"]]
            view.connectPort(node.outPorts[connection["outPortPosition"]])
        })
    }

    function forEachView(callback) {
        var i = 0
        while (i < viewsModel.count) {
            var view = gridView.itemAtIndex(i)
            if (view === null) {
                break
            }
            callback(view)
            i++
        }
    }

    Connections {
        target: canvas
        function onNodeAdded(node) {
            forEachView(function (view) {
                view.nodeMenu.addNodeToMenu(node)
            })
        }

        function onNodeRemoved(node) {
            forEachView(function (view) {
                view.nodeMenu.removeNodeFromMenu(node)
            })
        }
    }
}
