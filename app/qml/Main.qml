import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import Theme 1.0
import Global 1.0

import "components/"
import "view/"
import "node/"
import "menu/"
import "statusbar/"

ApplicationWindow {
    id: root

    property alias configManager: configManager
    property alias nodeCreator: nodeCreator
    property alias canvas: canvas
    property alias fileHandler: fileHandler

    readonly property int searchPanelDefaultWidth: 182
    readonly property int viewAreaDefaultWidth: 382
    readonly property int favoritesbarDefaultHeight: 40
    readonly property int statusbarDefaultHeight: 234
    readonly property int defaultWindowWidth: 1280
    readonly property int defaultWindowHeight: 720

    readonly property bool closeNotAccepted: configManager.isConfigChanged
                                             || configManager.isConfigSet
    property bool isHandlingClose: false
    property bool isHandlingConfigFileDrop: false

    property var closeHandledCallback: null

    property Action restoreUiDefaultsAction: Action {
        text: qsTr("Restore UI Defaults")
        onTriggered: {
            statusBar.SplitView.preferredHeight = statusbarDefaultHeight
            viewArea.SplitView.preferredWidth = viewAreaDefaultWidth
            favoritesBar.SplitView.preferredHeight = favoritesbarDefaultHeight
            searchPanel.SplitView.preferredWidth = searchPanelDefaultWidth
        }
    }

    visible: true
    width: defaultWindowWidth
    height: defaultWindowHeight
    minimumWidth: 512
    minimumHeight: 288

    title: {
        let title = "Graph-ICS - "
        if (configManager.isConfigSet) {
            title += configManager.configFile
        } else {
            title += qsTr("New Config")
        }
        title += configManager.isConfigChanged ? "*" : ""
        return title
    }

    color: Theme.background

    menuBar: GMenuBar {
        id: menuBar
    }

    Component.onCompleted: {
        splitView.restoreState(Global.windowSettings.splitViewState)
        canvasSplitView.restoreState(Global.windowSettings.canvasSplitViewState)

        Global.printUserMessage = statusBar.printMessage
    }

    Component.onDestruction: {
        Global.windowSettings.splitViewState = splitView.saveState()
        Global.windowSettings.canvasSplitViewState = canvasSplitView.saveState()
    }

    onClosing: {
        close.accepted = !closeNotAccepted
        if (closeNotAccepted) {
            isHandlingClose = true
            configManager.configClearedCallback = () => {
                isHandlingClose = false
                if (closeHandledCallback) {
                    closeHandledCallback()
                    closeHandledCallback = null
                }
                Qt.quit()
            }
            configManager.newAction.trigger()
        } else {
            if (closeHandledCallback) {
                closeHandledCallback()
                closeHandledCallback = null
            }
        }
    }

    onWidthChanged: {
        canvas.calculateMinimumSize()
    }

    onHeightChanged: {
        canvas.calculateMinimumSize()
    }

    GConfigManager {
        id: configManager
    }

    GFileHandler {
        id: fileHandler
    }

    NodeCreator {
        id: nodeCreator
    }

    GSplitView {
        id: splitView

        anchors.fill: parent

        onResizingChanged: {
            if (resizing) {
                canvas.calculateMinimumSize()
            }
        }
        clip: true

        GSearchPanel {
            id: searchPanel

            SplitView.minimumWidth: 14
            SplitView.preferredWidth: searchPanelDefaultWidth
        }

        GSplitView {
            id: canvasSplitView

            orientation: Qt.Vertical

            SplitView.fillWidth: true

            onResizingChanged: {
                if (resizing) {
                    canvas.calculateMinimumSize()
                }
            }

            GFavoritesBar {
                id: favoritesBar
                clip: true
                SplitView.preferredHeight: favoritesbarDefaultHeight
                SplitView.minimumHeight: Theme.smallHeight
                SplitView.maximumHeight: Theme.largeHeight
            }

            GFlickable {
                id: canvasFlickable
                SplitView.fillHeight: true

                contentHeight: height
                contentWidth: width

                scrollHorizontal: canvas.isControlKeyPressed

                ScrollBar.vertical: GScrollBar {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    policy: ScrollBar.AlwaysOn
                    width: 14
                    visible: canvasFlickable.height < canvas.minimumHeight
                }

                ScrollBar.horizontal: GScrollBar {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 14
                    policy: ScrollBar.AlwaysOn
                    visible: canvasFlickable.width < canvas.minimumWidth
                }

                onWidthChanged: {
                    resizeCanvas()
                }

                onHeightChanged: {
                    resizeCanvas()
                }

                function resizeCanvas() {
                    if (width < canvas.minimumWidth) {
                        contentWidth = canvas.minimumWidth
                    } else {
                        contentWidth = width
                    }

                    if (height < canvas.minimumHeight) {
                        contentHeight = canvas.minimumHeight
                    } else {
                        contentHeight = height
                    }
                }

                GCanvas {
                    id: canvas
                    anchors.fill: parent

                    mouseArea.onWheel: {
                        canvasFlickable.scrollContent(wheel)
                    }
                    onMinimumSizeChanged: {
                        canvasFlickable.resizeCanvas()
                    }
                }

                DropArea {
                    id: fileDropArea

                    property var node: null
                    property int dropX: 0
                    property int dropY: 0

                    anchors.fill: parent

                    onDropped: {
                        if (!drop && !drop.hasText) {
                            return
                        }
                        if (drop.keys) {
                            let keys = drop.keys
                            if (keys.indexOf("Favorite") !== -1) {
                                Global.printUserMessage(
                                            qsTr("Try to drag & drop into the favorites bar at the top!"))
                                return
                            }
                        }
                        let filePath = String(drop.text)
                        filePath = fileIO.removePathoverhead(filePath)

                        let node = null

                        if (fileHandler.isImageFile(filePath)) {
                            node = nodeCreator.createNode("Image")
                        } else if (fileHandler.isVideoFile(filePath)) {
                            node = nodeCreator.createNode("Video")
                        } else if (fileHandler.isConfigFile(filePath)) {
                            isHandlingConfigFileDrop = true
                            configManager.configClearedCallback = function () {
                                isHandlingConfigFileDrop = false
                                configManager.openConfig(filePath)
                            }
                            configManager.newAction.trigger()
                        } else {
                            fileHandler.handleUnknownFile(filePath)
                        }

                        if (node) {
                            node.attributes.forEach(function (attribute) {
                                attribute.setValue(filePath)
                            })
                            // weird adhoc solution to drop the node in the middle of the mouse cursor
                            // ports and attributes are added dynamically to the node base
                            // -> node width and height are not finally defined when created
                            fileDropArea.dropX = drop.x
                            fileDropArea.dropY = drop.y
                            fileDropArea.node = node
                            node.visible = false

                            canvas.addNode(node)
                            node.runDropAnimation()
                            // timer used to clean up the Connection on the fileDropArea.node
                            // or else the node would teleport to the drop location if the width changes
                            dirtyTimer.restart()
                        }
                    }

                    Connections {
                        target: fileDropArea.node ? fileDropArea.node : null

                        function onWidthChanged() {
                            let node = fileDropArea.node
                            if (node && node.portsCreated) {
                                node.visible = true
                                node.x = fileDropArea.dropX - node.width / 2
                                canvas.positionNode(node, false)
                            }
                        }

                        function onHeightChanged() {
                            let node = fileDropArea.node
                            if (node) {
                                node.y = fileDropArea.dropY - node.height / 2
                                canvas.positionNode(node, false)
                            }
                        }
                    }
                    Timer {
                        id: dirtyTimer
                        interval: 500
                        repeat: false
                        onTriggered: {
                            fileDropArea.node = null
                        }
                    }
                }
            }

            GStatusbar {
                id: statusBar
                SplitView.preferredHeight: statusbarDefaultHeight
                SplitView.minimumHeight: minHeight
            }
        }

        GViewArea {
            id: viewArea
            SplitView.preferredWidth: viewAreaDefaultWidth
            SplitView.minimumWidth: minWidth
        }
    }

    function getAbsolutePosition(item) {
        var returnPos = {}
        returnPos.x = 0
        returnPos.y = 0
        if (item !== undefined && item !== null) {
            var parentValue = getAbsolutePosition(item.parent)
            returnPos.x = parentValue.x + item.x
            returnPos.y = parentValue.y + item.y
        }
        return returnPos
    }

    function clearCallbacks() {
        if (isHandlingClose) {
            isHandlingClose = false
            closeHandledCallback = null
            configManager.configClearedCallback = null
        }
        if (isHandlingConfigFileDrop) {
            isHandlingConfigFileDrop = false
            configManager.configClearedCallback = null
        }
    }

    Connections {
        target: Global

        function onSavingVideo() {
            clearCallbacks()
        }

        function onNodeDisconnectViewFailed(node) {
            clearCallbacks()
        }
    }
}
