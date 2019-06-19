import QtQuick 2.10
import QtQuick.Controls 2.4
import QtQuick.Controls 1.4
//
//import QtQuick.Controls 2.3
//
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
//
import Model.Image 1.0
//
//todos:
// - auf cmake-Projekt umstellen
// - Model integrieren
// - Knoten im Model verlinken
// - Layoutinfos im Model ergänzen
// - Konfiguration öffnen/speichern erlauben
// - Datei-öffnen-Dialog für Images
// - in Image Fehler ausgeben, falls nötig
// - Anzeigeframe definieren
// - Anzeige/Filterung durchführen
// - Scrollbalken für das Canvas
// - generische Befüllung der ToolBar mit allen registrierten Filtern
// - für numerische Felder auch null-Werte erlauben
// - ToolBar-Node-Drag visualisieren
// - Reine Tastaturbedienung zulassen
// - Nodenamen in Klassen definieren und in QML verwenden
// - Filterung effizienter machen - nur Bild berechnen, wenn nötig


//model adoption: http://doc.qt.io/qt-5/qtqml-cppintegration-topic.html


ApplicationWindow {
    Component.onCompleted: {configManager.openToolBarItems()} // beim Start des Programmes wird die Favoriten Toolbar erzeugt, die der Nutzer beim Beenden des Programmes hatte
    id: root
    visible: true
    width: 640
    height: 480
    title: qsTr(menuManager.windowTitle + menuManager.changedSymbol + " - Graph-ICS")

    property var selectedNodes: []
    property bool isConfigReadyToClear: false
    property alias canvas: canvas
    property int minWidthCanvas: 0

    menuBar: MenuBar {
        id: menuBar
        Menu {
            id: menu
            title: qsTr("File")
            MenuItem {
                text: qsTr("&New");
                shortcut: "Ctrl+N"
                onTriggered: {
                    if(menuManager.isNewConfigDialogAllowed()) {
                        newConfigDialog.showNormal();
                    }
                    else {
                        resetConfig();
                    }
                }
            }
            MenuItem {
                text: qsTr("Open...");
                shortcut: "Ctrl+O"
                onTriggered: {
                    openFileDialog.open();
                    menuManager.hasConfig = true;
                }
            }
            MenuItem {
                text: qsTr("Save");
                shortcut: "Ctrl+S"
                onTriggered: {
                    if(menuManager.windowTitle === menuManager.defaultWindowTitle) { // new Config, kein Pfad angegeben
                        saveFileDialog.open();
                    }

                    else { // file, das schon geöffnet wurde, Pfad existiert bereits
                        configManager.saveConfig(menuManager.filePath);
                    }
                    menuManager.configResetted();
                }
                enabled: menuManager.isSaveConfigAllowed();
            }
            MenuItem {
                text: qsTr("Save As...");
                onTriggered: {
                    saveFileDialog.open();
                    menuManager.configResetted();
                }
                enabled: menuManager.isSaveConfigAsAllowed();
            }
            MenuSeparator { }
            MenuItem {
                text: "Open Image"
                onTriggered: {
                    loadImageDialog.open();
                    menuManager.hasImage = true;
                }
            }
            MenuItem {
                text: "Clear Image"
                onTriggered: {
                    root.splitView.imageView.removeImage();
                    menuManager.hasImage = false;
                    menuManager.hasloadedImage = false;
                }
                enabled: menuManager.isClearImageAllowed();
            }
            MenuItem {
                text: "Save Image As"
                onTriggered: {
                    saveImageDialog.open();
                }
                enabled: menuManager.isSaveImageAsAllowed();
            }
            MenuSeparator {}
            MenuItem {
                text: qsTr("Exit");
                shortcut: "Ctrl+Q"
                onTriggered: {
                    Qt.quit();
                }
            }
        }
        Menu {
            id: nodesMenu
            title: qsTr("Edit")
            MenuItem {
                text: qsTr("Remove Nodes");
                onTriggered: {
                    for (var i=0; i<canvas.nodes.length; i++) {
                        var node = canvas.nodes[i];
                        if(node.isSelected === true) {
                            canvas.removeNode(node);
                            i--; // damit index richtig gesetzt wird
                        }
                    }
                    menuManager.hasSelectedNodes = false;
                }
                enabled: menuManager.isEditAllowed();
            }
            MenuItem {
                text: qsTr("Copy");
                shortcut: "Ctrl+C"
                onTriggered: {
                    selectedNodes = [];
                    copySelectedNodes();
                }
                enabled: menuManager.isEditAllowed();
            }
            MenuItem {
                text: qsTr("Paste");
                shortcut: "Ctrl+V"
                onTriggered: {
                    pasteSelectedNodes();
                }
                enabled: menuManager.isPasteAllowed();

            }
            MenuItem {
                text: qsTr("Duplicate");
                shortcut: "Ctrl+D"
                onTriggered: {
                    selectedNodes = [];
                    copySelectedNodes();
                    pasteSelectedNodes();
                    selectedNodes = [];
                    menuManager.hasNodesToPaste = false;
                }
                enabled: menuManager.isEditAllowed();
            }
        }
        Menu {
            enabled: false
            title: "View"
            MenuItem {
                text: "Show Image"
                enabled: menuManager.isViewAllowed()
                onTriggered: {

                    var node = menuManager.retrieveSelectedNode();
                    if(node.validate()) {
                        gImageProvider.img = node.model.getResult();
                        root.splitView.imageView.reload();
                    }
                }
            }
            MenuItem {
                text: "Remove Node"
                enabled: menuManager.isViewAllowed()
                onTriggered: {
                    var node = menuManager.retrieveSelectedNode();
                    node.parent.removeNode(node);
                }
            }
        }
        Menu {
            title: qsTr("Help")
            MenuItem {
                text: qsTr("&About us");
                onTriggered: {
                    popup.showNormal();
                }
            }
        }
        //        Menu {
        //            title: "Toolbar"
        //            MenuItem {
        //                text: "Configure Toolbar"
        //                onTriggered: {
        //                    configureToolbar.showNormal();
        //                }
        //            }
        //        }
    }

    FileDialog {
        id: openFileDialog
        nameFilters: ["Json files (*.json)", "All files (*)"]
        onAccepted: configManager.openConfig(openFileDialog.fileUrl)
    }
    FileDialog {
        id: saveFileDialog
        selectExisting: false
        nameFilters: ["Json files (*.json)", "All files (*)"]
        selectedNameFilter: "Json files (*)"
        onAccepted: {
            configManager.saveConfig(saveFileDialog.fileUrl);
            if(isConfigReadyToClear === true) {
                resetConfig();
                isConfigReadyToClear = false;
            }
        }
    }
    FileDialog {
        id: loadImageDialog
        nameFilters: [ "Image files (*.png *.jpg)", "All files (*)" ]
        selectedNameFilter: "Image files (*)"
        onAccepted: {
            gImageProvider.img = gImageProvider.loadImage(loadImageDialog.fileUrl);
            root.splitView.imageView.reloadNewImage(loadImageDialog.fileUrl);
            menuManager.hasloadedImage = true;
        }
    }
    FileDialog {
        id: saveImageDialog
        selectExisting: false
        nameFilters: [ "Image files (*.png *.jpg)", "All files (*)" ]
        selectedNameFilter: "Image files (*)"
        onAccepted: gImageProvider.saveImageToFile(gImageProvider.img, saveImageDialog.fileUrl);
    }

    function createFilter(compName, mouseX, mouseY, absX, height) {
        return createNode("filter/" + compName, mouseX, mouseY, absX, height);
    }

    function createNode(compName, mouseX, mouseY, absX, height) {
        var component = Qt.createComponent(compName + ".qml");
        var node = component.createObject(canvas);

        // node.x = Math.max(mouseX + absX, 10 + node.portIn.viewPort.width);
        node.x = Math.max(mouseX + absX, 10 + node.portOut.viewPort.width);
        node.x = Math.min(node.x, canvas.width - node.width - node.portOut.viewPort.width);
        node.y = Math.max(mouseY - toolBar.height + (toolBar.height - height) / 2, 10);
        node.y = Math.min(node.y, canvas.height - node.height)
        canvas.nodes.push(node);

        menuManager.updateConfig(); // nodes Array wurde verändert
        return node;
    }

    toolBar: GToolBar {
        id: toolBar
    }

    property alias splitView: splitView

    SplitView {
        id: splitView
        anchors.fill: parent
        orientation: Qt.Horizontal

        property alias imageView: imageView

        MouseArea {
            id: canvasMouseArea
            width: parent.width * 0.7
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            Layout.minimumWidth: minWidthCanvas
            onWidthChanged: { // damit man die Image View nicht über bestehende Knoten ziehen kann
                resizeImageView();
            }
            GCanvas {
                id: canvas
                anchors.fill: parent
            }
            onClicked: {
                if (mouse.button === Qt.RightButton)
                    canvasContextMenu.popup();
            }
            Menu {
                id: canvasContextMenu
                MenuItem {
                    text: "New"
                    onTriggered: {
                        configManager.clearConfig();
                        menuManager.prepareNewConfig();
                    }
                }
                MenuItem {
                    text: "Open"
                    onTriggered: {
                        openFileDialog.open();
                        menuManager.hasConfig = true;
                    }
                }
                MenuItem {
                    text: "Save"
                    onTriggered: {
                        if(menuManager.windowTitle === menuManager.defaultWindowTitle) { // new Config, kein Pfad angegeben
                            saveFileDialog.open();
                        }

                        else { // file, das schon geöffnet wurde, Pfad existiert bereits
                            configManager.saveConfig(menuManager.filePath);
                        }
                        menuManager.configResetted();
                    }
                    enabled: menuManager.isSaveConfigAllowed();
                }
                MenuItem { text: "Save As"
                    onTriggered: {
                        saveFileDialog.open();
                        menuManager.configResetted();
                    }
                    enabled: menuManager.isSaveConfigAsAllowed();
                }
            }
        }
        MouseArea {
            id: mouseArea
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            Image {
                id: imageView
                anchors.fill: parent
                width: parent.width
                property int counter : 0
                source: "image://gimg/id=" + counter
                fillMode: Image.PreserveAspectFit

                function reload() {
                    counter++;
                    source= "image://gimg/id=" + counter;
                    menuManager.hasImage = true;
                }
                function reloadNewImage(path) {
                    source = path;
                }
                function removeImage()
                {
                    source = "";
                }
            }
            onClicked: {
                toolBar.toolbarCombobox.state = toolBar.toolbarCombobox.state==="";
                if (mouse.button === Qt.RightButton)
                    viewerContextMenu.popup()
            }
            Menu {
                id: viewerContextMenu
                MenuItem {
                    text: "Open Image"
                    onTriggered: {
                        loadImageDialog.open();
                        menuManager.hasImage = true;
                    }
                }
                MenuItem {
                    text: "Clear Image"
                    onTriggered: {
                        root.splitView.imageView.removeImage();
                        menuManager.hasImage = false;
                        menuManager.hasloadedImage = false;
                    }
                    enabled: menuManager.isClearImageAllowed();
                }
                MenuItem {
                    text: "Save Image As"
                    onTriggered: {
                        saveImageDialog.open();
                    }
                    enabled: menuManager.isSaveImageAsAllowed();
                }
            }
        }
    }
    ConfigManager {
        id: configManager
    }
    MenuManager {
        id: menuManager
    }
    NewConfigDialog {
        id: newConfigDialog
    }
    InfoPopup {
        id: popup
    }
    ConfigureToolbar {
        id: configureToolbar
    }

    function resetConfig() {
        menuManager.configResetted();
        configManager.clearConfig();
        menuManager.prepareNewConfig();
    }

    function createSelectedNode (component, node) {
        var newNode = component.createObject(canvas);
        newNode.x = node.x+10;
        newNode.y = node.y;
        canvas.nodes.push(newNode);
    }
    function copySelectedNodes() {
        for(var i=0; i<canvas.nodes.length; i++) {
            var node = canvas.nodes[i];
            if(node.isSelected) {
                var modelName = String(node);
                var buf = modelName.split("_"); // name des Filters wird aus dem String rausgenommen
                var name = buf[0];
                var obj = {name: name, x: node.x, y: node.y};
                selectedNodes.push(obj);
                menuManager.updatePaste();
            }
        }
    }
    function pasteSelectedNodes() {
        for (var i=0; i<selectedNodes.length; i++) {
            var node = selectedNodes[i];
            if(node.name === "Image") {
                var componentImage = Qt.createComponent(node.name + ".qml");
                createSelectedNode(componentImage, node);
            }
            else {
                var componentNode = Qt.createComponent("filter/" + node.name + ".qml");
                createSelectedNode(componentNode, node);
            }
        }
    }
    function resizeImageView() {
        if(canvas.nodes.length > 0) {
            var maxX;
            var nodeMaxX = canvas.nodes[0];
            for(var i=1; i<canvas.nodes.length; i++) {
                var currentNode = canvas.nodes[i];
                if(currentNode.x+currentNode.width > nodeMaxX.x+nodeMaxX.width) {
                    nodeMaxX = currentNode;
                }
            }
            minWidthCanvas = nodeMaxX.x+nodeMaxX.width+nodeMaxX.portOut.viewPort.width;
        }
    }
}
