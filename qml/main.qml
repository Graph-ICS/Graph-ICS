import QtQuick 2.15

import QtQuick.Controls 2.15 as QQC2
import QtQuick.Controls.Material 2.15
import QtQml.Models 2.15

import QtQuick.Controls 1.4 as QQC1
import QtQuick.Controls.Styles 1.4

//
//import QtQuick.Controls 2.3
//
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
//

import Theme 1.0
import "components/"

//
// TODO:
// (- Reine Tastaturbedienung zulassen)


QQC2.ApplicationWindow {

    onClosing: {
        // stop the video if one is playing
        workerThread.pauseVideo()
    }

    id: root
    visible: true
    width: 1024
    height: 576
    minimumWidth: 512
    minimumHeight: 288
    color: Theme.mainColor

    onWidthChanged: {
        resizeCanvas()
    }

    onHeightChanged: {
        resizeCanvas()
    }

    title: qsTr("Graph-ICS - " + menuBar.menuManager.windowTitle + menuBar.menuManager.changedSymbol)

    property alias menuManager: menuBar.menuManager
    property alias configManager: menuBar.configManager

    property alias canvas: canvas
    property int minWidthCanvas: 200
    property int minHeightCanvas: 200
    property int sidePanelWidth: 182

    property var nodeQueue: []

    menuBar: GMenuBar{
        id: menuBar
    }

    header: GFavoritesBar {
        id: favoritesBar
        search.onTextEdited: {
            sidePanel_widthAnimation.running = true
            if(!sidePanel.googleSearch){
                if(search.text == ""){
                    sidePanel.reload()
                } else {
                    sidePanel.search(search.text)
                }
            }
        }
        search.onAccepted: {
            sidePanel_widthAnimation.running = true
            if(sidePanel.googleSearch){
                if(search.text == ""){
                    sidePanel.listModel.clear()
                } else {
                    sidePanel.search(search.text)
                }
            }
        }

    }

    property alias splitView: splitView

    QQC1.SplitView {
        id: splitView
        anchors.fill: parent
        orientation: Qt.Horizontal

        // damit man nicht ueber die Knoten ziehen kann
        onResizingChanged: {
            resizeCanvas()
        }

        handleDelegate: Rectangle {
            implicitHeight: 1
            implicitWidth: 1
            color: Theme.accentEnabled ? Theme.accentColor : Theme.mainColor
        }

        GSidePanel {
            id: sidePanel
            height: parent.height

            PropertyAnimation{
                id: sidePanel_widthAnimation
                target: sidePanel
                property: "width"
                from: sidePanel.width
                to: sidePanelWidth
                duration: 150
            }

        }

        QQC1.SplitView {
            id: canvasSplitView
            Layout.minimumWidth: canvas.minWidth
            orientation: Qt.Vertical

            handleDelegate: Rectangle {
                implicitHeight: 1
                implicitWidth: 1
                color: Theme.accentEnabled ? Theme.accentColor : Theme.mainColor
            }

            // damit man nicht ueber die Knoten ziehen kann
            onResizingChanged: {
                resizeCanvas()
            }

            MouseArea {
                id: canvasMouseArea
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                Layout.minimumHeight: canvas.minHeight
                Layout.fillHeight: true
                hoverEnabled: true
                width: 614

                onClicked: {
                    forceActiveFocus()
                    if (mouse.button === Qt.RightButton){
                        canvasContextMenu.popup()
                    }
                }

                GCanvas {
                    id: canvas
                    property int minWidth: minWidthCanvas
                    property int minHeight: minHeightCanvas
                    anchors.fill: parent
                }

                GMenu {
                    id: canvasContextMenu
                    QQC2.Action {
                        text: "New"
                        onTriggered: {
                            menuBar.newConfig()
                        }
                    }
                    QQC2.Action {
                        text: "Open"
                        onTriggered: {
                            menuBar.openConfig()
                        }
                    }
                    QQC2.Action {
                        text: "Save"
                        onTriggered: {
                            menuBar.saveConfig()
                        }
                        enabled: menuManager.isSaveConfigAllowed();
                    }
                    QQC2.Action {
                        text: "Save As"
                        onTriggered: {
                            menuBar.saveConfigAs()
                        }
                        enabled: menuManager.isSaveConfigAsAllowed();
                    }
                }
            }

            GStatusbar {
                id: statusBar
            }
        }

        property alias imageView: imageView

        Rectangle {
            id: imageRect
            color: Theme.mainColor
            Layout.minimumWidth: 42

            MouseArea {
                id: mouseArea
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                anchors.fill: parent

                Image {
                    id: imageView
//                    anchors.verticalCenterOffset: -favoritesBar.height
                    states: [
                        State {
                            name: "scale"
                            AnchorChanges {
                                target: imageView
                                anchors.left: mouseArea.left
                                anchors.right: mouseArea.right
                                anchors.top: mouseArea.top
                                anchors.bottom: mouseArea.bottom
                            }
                        },
                        State {
                            name: "normal"
                            AnchorChanges {
                                target: imageView
                                anchors.horizontalCenter: mouseArea.horizontalCenter
                                anchors.verticalCenter: mouseArea.verticalCenter
                            }
                        }
                    ]

                    width: parent.width

                    state: 'normal'
                    property int counter : 0
                    source: "image://gimg/id=" + counter
                    fillMode: Image.PreserveAspectFit

                    function reload() {
                        counter++;
                        source= "image://gimg/id=" + counter;
                        height = implicitHeight
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
                    forceActiveFocus()
                    if (mouse.button === Qt.RightButton)
                        viewerContextMenu.popup()
                }
                GMenu {
                    id: viewerContextMenu
                    QQC2.Action {
                        text: "Clear Image"
                        onTriggered: {
                            menuBar.clearImage()
                        }
                        enabled: menuManager.isClearImageAllowed()
                    }
                    QQC2.Action {
                        text: "Save Image As"
                        onTriggered: {
                            menuBar.fileDialog.open("save_image")
                        }
                        enabled: menuManager.isSaveImageAsAllowed()
                    }
                    QQC2.Action {
                        text: "Export Video"
                        onTriggered: {
                            menuBar.exportDialog.nodeToExport = canvas.getShownImageNode()
                            menuBar.exportDialog.showNormal()
                        }
                        enabled: menuManager.isExportVideoAllowed()
                    }
                }
            }
        }
    }

    QmlStringCreator {
        id: stringCreator
    }
    NodeWarning {
        id: nodeWarning
    }

    function createNode(compName, mouseX, mouseY, absX, height) {
        var node
        var path = "qrc:/nodes/" + compName

        // Konvention:
        // qml Datei in Ordner nodes Dateiname fuer Nodes mit suffix Node, fuer Filter analog suffix Filter
        // CamelCase zb. ImageNode.qml, ItkCannyEdgeDetectionFilter.qml

        if((compName !== "Image") && (compName !=="Video") && (compName !=="Camera")){
            path += "Filter"
        } else {
            path += "Node"
        }
        path += ".qml"
//        print(path)
        var component = Qt.createComponent(path);

        // Falls es eine Datei gibt wird das Objekt zu dieser erstellt (z.b. Image)
        if(component.status === Component.Ready){
            node = component.createObject(root);
        } else {
            var str = stringCreator.createNodeQmlString(compName)

            node = Qt.createQmlObject(str, root)
        }
        return node;
    }

    function resizeCanvas() {
        var maxX = minWidthCanvas
        var maxY = minHeightCanvas
        for(var i = 0; i < canvas.nodes.length; i++){
            var node = canvas.nodes[i]
            var nodeX = node.x + node.width + node.portOut.viewPort.width/2
            var nodeY = node.y + node.height
            if(nodeX > maxX){
                maxX = nodeX
            }
            if(nodeY > maxY){
                maxY = nodeY
            }
        }
        canvas.minWidth = maxX
        canvas.minHeight = maxY
    }

    function queueNode(node){

        if(nodeQueue.length == 0){
            canvas.setPipelineFlag(node, true)
        }
        nodeQueue.push(node)
        statusBar.queueNode(node)
    }

    Connections{
        target: workerThread

        function onImageProcessed(result) {

            // TODO:
            // print(result) gibt bei fehlendem input Image QVariant(QPixmap, QPixmap(null)) aus
            // herausfinden wie man das ausnutzen kann um die zuweisung zum ImageProvider zu verhindern

            gImageProvider.img = result
            imageView.reload()

            var node = nodeQueue.shift()

            node.isQueued = false
            statusBar.dequeueNode()
            canvas.resetShownImage()
            node.isImageShown = true
            canvas.setPipelineFlag(node, false)

            // set the Pipelineflag for the next Node in Line
            if(nodeQueue.length > 0){
                canvas.setPipelineFlag(nodeQueue[0], true)
            }
            menuManager.hasImage = true
        }

        function onVideoFrameProcessed(result){
            gImageProvider.img = result
            imageView.reload()

            var node = nodeQueue[0]
            if(!node.isImageShown){
                canvas.resetShownImage()
                node.isImageShown = true
            }
            menuManager.hasImage = true
        }
    }
}
