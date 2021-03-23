import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Dialogs 1.3

import Theme 1.0

import "components/"

QQC2.MenuBar {

    // laden der config files beim Start des Programms
    Component.onCompleted: {
        configManager.openFavoriteItems()
    }

    contentWidth: fileMenu.width + editMenu.width + viewMenu.width + helpMenu.width

    property alias fileDialog: fileDialog
    property alias menuManager: menuManager
    property alias configManager: configManager
    property alias exportDialog: exportDialog
    property bool isConfigReadyToClear: false
    property var selectedNodes: []

    delegate: GMenuBarItem{}

    background: Rectangle {
        color: Theme.contentDelegate.color.background.normal

        Rectangle {
            color: Theme.accentColor
            width: parent.width
            height: Theme.accentEnabled ? 1 : 0
            anchors.bottom: parent.bottom
        }
    }


    GMenu {
        id: fileMenu
        title: "File"

        QQC2.Action {
            text: "New"
            shortcut: "Ctrl+N"
            onTriggered: {
                newConfig()
            }
        }

        QQC2.Action {
            text: "Open..."
            shortcut: "Ctrl+O"
            onTriggered: {
                openConfig()
            }
        }

        QQC2.Action {
            text: "Save"
            shortcut: "Ctrl+S"
            onTriggered: {
                saveConfig()
            }
            enabled: menuManager.isSaveConfigAllowed()
        }

        QQC2.Action {
            text: "Save As"
            onTriggered: {
                saveConfigAs()
            }
            enabled: menuManager.isSaveConfigAsAllowed()
        }

//        QQC2.MenuSeparator {
//            contentItem: Rectangle {
//                implicitWidth: 200
//                implicitHeight: 1
//                color: Theme.accentColor
//            }
//        }

//        QQC2.Action {
//            text: "Save Image As"
//            onTriggered: {
//                fileDialog.open("save_image")
//            }
//            enabled: menuManager.isSaveImageAsAllowed()
//        }

//        QQC2.Action {
//            text: "Export Video"
//            onTriggered: {
//                exportDialog.nodeToExport = canvas.getShownImageNode()
//                exportDialog.showNormal()
//            }
//            enabled: menuManager.isExportVideoAllowed()
//        }

        QQC2.MenuSeparator {
            contentItem: Rectangle {
                implicitWidth: 200
                implicitHeight: 1
                color: Theme.accentColor
            }
        }

        QQC2.Action {
            text: "Exit"
            shortcut: "Ctrl+Q"
            onTriggered: {
                root.close()
            }
        }
    }

    GMenu {
        id: editMenu
        title: "Edit"
        QQC2.Action {
            text: "Remove selected Nodes"
            shortcut: "del"
            onTriggered: {
               removeSelectedNodes()
            }
            enabled: menuManager.isEditAllowed()
        }

        QQC2.Action {
            text: "Copy"
            shortcut: "Ctrl+C"
            onTriggered: {
                selectedNodes = []
                copySelectedNodes()
            }
            enabled: menuManager.isEditAllowed()
        }

        QQC2.Action {
            text: "Paste"
            shortcut: "Ctrl+V"
            onTriggered: {
                pasteSelectedNodes()
            }
            enabled: menuManager.isPasteAllowed()
        }
    }

    GMenu {
        id: viewMenu
        title: "View"

        QQC2.Action {
            text: "Show Image"
            enabled: menuManager.isViewAllowed()
            onTriggered: {
                var node = menuManager.retrieveSelectedNode()
                node.processNode()
            }
        }
        // TODO: maybe reactivate
//        QQC2.Action {
//            text: "Clear Image"
//            onTriggered: {
//                clearImage()
//            }
//            enabled: menuManager.isClearImageAllowed()
//        }

        QQC2.MenuSeparator {
            contentItem: Rectangle {
                implicitWidth: 200
                implicitHeight: 1
                color: Theme.accentColor
            }
        }

        QQC2.Action {
            text: "Settings"
            onTriggered: {
                settings.show()
            }
        }

    }

    GMenu {
        id: helpMenu
        title: "Help"

        QQC2.Action {
            text: "About us"
            onTriggered: {
                popup.showNormal();
            }
        }
    }

    GSettings {
        id: settings
    }

    GExportDialog {
        id: exportDialog
    }

    MenuManager {
        id: menuManager
    }

    ConfigManager {
        id: configManager
    }

    NewConfigDialog {
        id: newConfigDialog
    }

    InfoPopup {
        id: popup
    }

    GFileDialog {
        id: fileDialog

        onAccepted: {
            switch(state){
                case 'open_json':
                    configManager.openConfig(fileUrl)

                    break
                case 'save_json':
                    configManager.saveConfig(fileUrl)
                    if(isConfigReadyToClear) {
                        resetConfig();
                        isConfigReadyToClear = false;
                    }
                    break
                case 'save_image':
                    fileIO.writeImageFile(fileUrl, currentNode.model)
                    break
                case 'save_video':
                    break
                default:
                    break
            }
        }
         property var currentNode: null
    }

    function removeSelectedNodes(){
        for (var i=0; i<canvas.nodes.length; i++) {
            var node = canvas.nodes[i]
            if(node.isSelected === true) {
                if(node.isInPipeline || node.isInQueue){
                    continue
                }
                canvas.removeNode(node)
                menuManager.updateConfig()
                i-- // damit index richtig gesetzt wird
            }
        }
        var selectedNodes = false
        for(var j = 0; j < canvas.nodes.length; j++){
            if(canvas.nodes[j].isSelected){
                selectedNodes = true
            }
        }
        menuManager.hasSelectedNodes = selectedNodes
        menuManager.updateSelectedNodes();
    }

    function copySelectedNodes() {
        for(var i=0; i<canvas.nodes.length; i++) {
            var node = canvas.nodes[i];
            if(node.isSelected) {
                selectedNodes.push(node);
                menuManager.updatePaste();
            }
        }
    }

    function pasteSelectedNodes() {
        canvas.deselectAllNodes()
        for (var i = 0; i < selectedNodes.length; i++) {
            var node = selectedNodes[i];
            var obj = createNode(node.objectName)
            obj.parent = canvas
            obj.select()
            obj.x = node.x + 10
            obj.y = node.y + 10
            canvas.nodes.push(obj)
        }
    }

    function clearImage() {
        viewArea.removeImage()
        menuManager.hasImage = false;
    }

    function clearViews(){
        viewArea.clearAll()
        menuManager.hasImage = false;
    }

    function resetConfig() {
        menuManager.configResetted();
        configManager.clearConfig();
        menuManager.prepareNewConfig();
        clearViews()
    }

    function newConfig() {
        if(menuManager.isNewConfigDialogAllowed()) {
            newConfigDialog.showNormal()
        }
        else {
            resetConfig()
        }
    }

    function openConfig() {
        fileDialog.open("open_json")
        menuManager.hasConfig = true
        menuManager.configResetted()
    }

    function saveConfig() {
        if(menuManager.windowTitle === menuManager.defaultWindowTitle) { // new Config, kein Pfad angegeben
            fileDialog.open("save_json");

        } else { // file, das schon geöffnet wurde, Pfad existiert bereits
            configManager.saveConfig(menuManager.filePath);
        }
        menuManager.configResetted();
    }

    function saveConfigAs() {
        fileDialog.open("save_json")
        menuManager.configResetted()
    }

}
