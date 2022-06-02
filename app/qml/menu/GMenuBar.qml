import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.0
import QtWebEngine 1.0

import Theme 1.0
import Global 1.0

import "../components/"

MenuBar {
    id: menubar

    contentWidth: fileMenu.width + editMenu.width + helpMenu.width

    property var connectionDialog: null

    Component.onCompleted: {
        if (appInfo.remotePluginEnabled()) {
            connectionDialog = connectionDialogComponent.createObject(menubar)
            fileMenu.insertItem(5, connectionsMenuItemComponent.createObject(
                                    fileMenu))
        }
        // TODO: Need to find hosting solution for online updates
        // checkForUpdatesAction.trigger()
    }

    delegate: GMenuBarItem {}

    background: Rectangle {
        color: Theme.background

        Rectangle {
            color: Theme.accentEnabled ? Theme.primary : Theme.darkMode ? Qt.darker(Theme.onsurface) : Qt.lighter(Theme.onsurface)
            width: parent.width
            height: 1
            anchors.bottom: parent.bottom
        }
    }

    property Action openSettingsAction: Action {
        text: qsTr("Settings...")
        onTriggered: {
            settings.show()
        }
    }

    property Action exitAppAction: Action {
        text: qsTr("Exit")
        shortcut: "Ctrl+Q"
        onTriggered: {
            root.close()
        }
    }

    property Action openHelpBrowserAction: Action {
        text: qsTr("Online Help...")
        onTriggered: {
            helpBrowser.showNormal()
        }
    }

    property Action openAboutAction: Action {
        text: qsTr("About...")
        onTriggered: {
            aboutWindow.showNormal()
        }
    }

    //    property Action checkForUpdatesAction: Action {
    //        text: qsTr("Check for Updates")
    //        onTriggered: {
    //            Global.printUserMessage(qsTr("Checking for Updates..."))
    //            appUpdater.checkForUpdates()
    //        }
    //    }
    GMenu {
        id: fileMenu
        title: qsTr("File")

        GMenuItem {
            action: configManager.newAction
        }

        GMenuItem {
            action: configManager.openAction
        }

        GMenuItem {
            action: configManager.saveAction
        }

        GMenuItem {
            action: configManager.saveAsAction
        }

        MenuSeparator {
            contentItem: Rectangle {
                implicitWidth: 200
                implicitHeight: 1
                color: Theme.primary
            }
        }

        GMenuItem {
            action: openSettingsAction
        }

        MenuSeparator {
            contentItem: Rectangle {
                implicitWidth: 200
                implicitHeight: 1
                color: Theme.primary
            }
        }

        GMenuItem {
            action: exitAppAction
        }
    }

    GMenu {
        id: editMenu
        title: qsTr("Edit")

        GMenuItem {
            action: canvas.cutSelectedNodesAction
        }

        GMenuItem {
            action: canvas.copySelectedNodesAction
        }

        GMenuItem {
            action: canvas.pasteSelectedNodesAction
        }

        GMenuItem {
            action: canvas.duplicateSelectedNodesAction
        }

        GMenuItem {
            action: canvas.removeSelectedNodesAction
        }
    }

    GMenu {
        id: runMenu
        title: qsTr("Run")

        GMenuItem {
            text: action ? action.text : qsTr("Play")
            action: Global.focusedTask ? Global.focusedTask.playAction : null
            enabled: action ? action.enabled : false
        }

        GMenuItem {
            text: action ? action.text : qsTr("Pause")
            action: Global.focusedTask ? Global.focusedTask.pauseAction ? Global.focusedTask.pauseAction : null : null
            enabled: action ? action.enabled : false
        }

        GMenuItem {
            text: action ? action.text : qsTr("Stop")
            action: Global.focusedTask ? Global.focusedTask.stopAction ? Global.focusedTask.stopAction : null : null
            enabled: action ? action.enabled : false
        }

        GMenuItem {
            text: action ? action.text : qsTr("Open Camera")
            action: Global.focusedTask ? Global.focusedTask.openCameraAction ? Global.focusedTask.openCameraAction : null : null
            enabled: action ? action.enabled : false
        }

        GMenuItem {
            text: action ? action.text : qsTr("Close Camera")
            action: Global.focusedTask ? Global.focusedTask.closeCameraAction ? Global.focusedTask.closeCameraAction : null : null
            enabled: action ? action.enabled : false
        }

        GMenuItem {
            text: action ? action.text : qsTr("Record")
            action: Global.focusedTask ? Global.focusedTask.recordAction ? Global.focusedTask.recordAction : null : null
            enabled: action ? action.enabled : false
        }
    }

    GMenu {
        id: helpMenu
        title: qsTr("Help")

        GMenuItem {
            action: openHelpBrowserAction
        }

        GMenuItem {
            action: openAboutAction
        }

        MenuSeparator {
            contentItem: Rectangle {
                implicitWidth: 200
                implicitHeight: 1
                color: Theme.primary
            }
        }

        GMenuItem {
            action: root.restoreUiDefaultsAction
        }

        //        MenuSeparator {
        //            contentItem: Rectangle {
        //                implicitWidth: 200
        //                implicitHeight: 1
        //                color: Theme.primary
        //            }
        //        }
        //        GMenuItem {
        //            action: checkForUpdatesAction
        //        }
    }

    Component {
        id: connectionDialogComponent
        GConnectionDialog {}
    }

    Component {
        id: connectionsMenuItemComponent
        GMenuItem {
            action: Action {
                text: qsTr("Server Connection...")
                onTriggered: {
                    connectionDialog.show()
                }
            }
        }
    }

    GSettings {
        id: settings
    }

    AboutWindow {
        id: aboutWindow
    }

    //    YesNoDialog {
    //        id: updateNotification
    //        title: qsTr("Graph-ICS - Update")

    //        onActiveChanged: yesButton.highlightAnimation.running = true
    //        text: qsTr("A new <a style='color:" + String(Theme.secondary)
    //                   + ";' >update</a> is available!<p>Do you want to install it?</p>")

    //        onYes: {
    //            close()
    //            root.closeHandledCallback = appUpdater.startUpdateTool
    //            root.close()
    //        }

    //        onNo: {
    //            close()
    //        }
    //    }
    Window {
        id: helpBrowser
        width: 1024
        height: 750
        WebEngineView {
            anchors.fill: parent
            url: Global.onlineDocsLink
        }
    }

    GFindHelpWindow {
        id: findHelpWindow
        Component.onCompleted: visible = Global.behaviorSettings.showFindHelp
    }

    //    Connections {
    //        target: appUpdater

    //        function onCheckForUpdatesFinished(updateAvailable) {
    //            if (updateAvailable) {
    //                updateNotification.showNormal()
    //                Global.printUserMessage(qsTr("Update available!"))
    //            } else {
    //                Global.printUserMessage(qsTr("No updates available!"))
    //            }
    //        }
    //    }
}
