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
import "view/"
//
// TODO:
// (- Reine Tastaturbedienung zulassen)


QQC2.ApplicationWindow {

    onClosing: {
        // stop the video if one is playing
        scheduler.stop()
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
    property int minWidthCanvas: 0
    property int minHeightCanvas: 148
    property int sidePanelWidth: 182

    property var taskQueue: []
    property var nodeQueue: []
    property var synchronizedNodes: []

    menuBar: GMenuBar{
        id: menuBar
    }

    header: GFavoritesBar {
        id: favoritesBar
        search.onTextEdited: {
            sidePanel_widthAnimation.running = true
            if(sidePanel.searchOnType){
                sidePanel.search(search.text)
            }
            if(search.text == ""){
                sidePanel.reload()
            }
        }
        search.onAccepted: {
            sidePanel_widthAnimation.running = true
            if(!sidePanel.searchOnType){
                if(search.text == ""){
                    sidePanel.reload()
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
            Layout.minimumWidth: statusBar.minWidth > canvas.minWidth ? statusBar.minWidth : canvas.minWidth

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
                Layout.minimumWidth: canvas.minWidth
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
                Layout.minimumHeight: minHeight
            }
        }

        GViewArea {
            id: viewArea
            Layout.minimumWidth: minWidth
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

        var nodeCount = canvas.getNodeCounter(compName)

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

        node.number = nodeCount
        node.rect.calculateNodeSize()

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

        if(taskQueue.length == 0){
            canvas.setPipelineFlag(node, true)
        }
        var nodeArray = []
        nodeArray.push(node)
        taskQueue.push(nodeArray)
        statusBar.queueNode(node)
        scheduler.add([node.model], false)
    }

    function queueSynchronizedProcess(nodes){
        synchronizedNodes = nodes
        taskQueue.push(synchronizedNodes)
        var models = []
        synchronizedNodes.forEach(function setFlagAndGetModel(node){
            canvas.setPipelineFlag(node, true)
            models.push(node.model)
            node.isQueued = true
        })
        scheduler.add(models, true)
    }

    Connections{
        target: scheduler

//        function onUpdateStatusbar(){
//            if(taskQueue.length > 0){
//                var nodes = taskQueue.shift()

//                nodes.forEach(function setFlag(node){
//                    canvas.setPipelineFlag(node, false)
//                    node.isQueued = false
//                })

//                statusBar.dequeueNode()
//                // set the Pipelineflag for the next Node in Line
//                if(taskQueue.length > 0){
//                    taskQueue[0].forEach(function setFlag(node){
//                        canvas.setPipelineFlag(node, true)
//                    })
//                }
//            }
//        }

//        function onResultReady(result, index){
//            var nodes = taskQueue[0]
//            viewArea.updateViews(nodes[index], result)
////            nodes.push(nodes.shift())
////            taskQueue[0] = nodes
//        }

//        function onDisplayMessageForNode(message, indexInTask){
//            var nodes = taskQueue[0]
//            var node = nodes[indexInTask]
//            statusBar.printMessage(node.title.title + ": " + message)
//        }

//        function onDisplayMessage(message){
//            statusBar.printMessage(message)
//        }

    }

    function getAbsolutePosition(item) {
          var returnPos = {};
          returnPos.x = 0;
          returnPos.y = 0;
          if(item !== undefined && item !== null) {
              var parentValue = getAbsolutePosition(item.parent);
              returnPos.x = parentValue.x + item.x;
              returnPos.y = parentValue.y + item.y;
          }
          return returnPos;
    }

}
