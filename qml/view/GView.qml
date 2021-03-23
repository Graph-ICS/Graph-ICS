import QtQuick 2.15
import QtCharts 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import Theme 1.0
import Model.View 1.0

import QtGraphicalEffects 1.12
import "../components/"

Item {
    id: view
    property int minWidth: bgRect.width + 8
    property int minHeight: bgRect.height + 8
    property alias currentIndex: stackLayout.currentIndex

    property alias imageView: imageView
    property alias diagramView: diagramView
    property alias model: model

    property color backgroundColor: "gray"
    property color shownNodeColor: backgroundColor

    // all nodes with a connection to this view
    property var connectedNode: null
    property var predNode: null

    property bool nodeShown: false

    readonly property int nullViewIndex: 0
    readonly property int imageViewIndex: 1
    readonly property int diagramViewIndex: 2

    MouseArea {
        id: dNd
        z:1
        anchors.fill: parent
        drag.axis: Drag.XAndYAxis
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        property var dragObject: null
        pressAndHoldInterval: 300
        onPressAndHold: {
            if(mouse.button === Qt.RightButton){
                return
            }

            dragObject = Qt.createQmlObject("import QtQuick 2.15; Rectangle {property var view: null}", root)
            // init rectangle
            dragObject.color = backgroundColor
            dragObject.height = 24
            dragObject.width = dragObject.height
//            dragObject.border.width = 2
//            dragObject.border.color = Qt.darker(backgroundColor)
            dragObject.radius = 8
            // set view property
            dragObject.view = view

            // map absolute position to mouseArea
            var pos = root.getAbsolutePosition(dNd)
            dragObject.x = pos.x + mouseX - dragObject.width/2
            dragObject.y = pos.y + mouseY - dragObject.height/2

            // drag & drop initialization
            drag.target = dragObject
            dragObject.Drag.active = true
            dragObject.Drag.source = dragObject
            // drag hotspot: when the dragged item is in a drop area (here: more than half inside the drop area)
            dragObject.Drag.hotSpot.x = dragObject.width / 2
            dragObject.Drag.hotSpot.y = dragObject.height / 2
        }

        onReleased: {
            if(dragObject !== null){
                // try dropping
                dragObject.Drag.drop()
                // delete object
                dragObject.destroy()
                // important line: without results crash
                drag.target = null
            }

        }

        onClicked: {
            forceActiveFocus()
            if (mouse.button === Qt.RightButton){
                menu.popup()
            }
        }

        GMenu {
            id: menu

            Action {
                text: "Remove Node Connection"
                onTriggered: {
                    removeNodeConnection()
                }
                enabled: connectedNode !== null
            }

            Action {
                text: "Clear Image"
                onTriggered: {
                    clearView()
                }
                enabled: stackLayout.currentIndex == imageViewIndex
            }
            Action {
                text: "Save Image As"
                onTriggered: {
                    menuBar.fileDialog.currentNode = connectedNode
                    menuBar.fileDialog.open("save_image")
                }
                enabled: stackLayout.currentIndex == imageViewIndex
            }
            Action {
                text: "Export Video"
                onTriggered: {
                    menuBar.exportDialog.nodeToExport = connectedNode
                    menuBar.exportDialog.showNormal()
                }
                enabled: stackLayout.currentIndex == imageViewIndex ? menuManager.isExportVideoAllowed(connectedNode) : false
            }
        }
    }

    // color indicator
    Rectangle {
        id: bgRect
        z:1
        anchors.top: parent.top
        anchors.topMargin: 4
        anchors.horizontalCenter: parent.horizontalCenter
        height: 12
        width: 12
        radius: 4
        color: backgroundColor
    }


    StackLayout {
        id: stackLayout
//        currentIndex: tabbar.currentIndex
        anchors.fill: parent
        // Empty View: 0
        Item {

        }

        // Image View: 1 GImage
        Item {
            GImageView {
                id: imageView
                anchors.fill: parent
                color: Theme.mainColor
            }
        }
        // Diagram View: 2 GData
        Item {
            GDiagramView {
                id: diagramView
                anchors.fill: parent
                color: Theme.mainColor
            }
        }
    }

    View_Model {
        id: model
    }

    Connections {
        target: model

        function onUpdateView(result){
            viewArea.updateViews(connectedNode, result)
        }

        function onStopTask(){
            stopTask()
        }

        function onPrintMessageForNode(message){
            statusBar.printMessageForNode(connectedNode, message)
        }
    }

    function stopTask(){
        connectedNode.isQueued = false
        if(connectedNode.isInPipeline){
            canvas.setPipelineFlag(connectedNode, false)
        }
        statusBar.removeTask(connectedNode)
        statusBar.fixPipelineFlag()
    }

    function updateView(result){
        switch(connectedNode.model.getOutputType()){
        case "GImage":
            imageView.setImage(result)
            stackLayout.currentIndex = imageViewIndex
            break
        case "GData":
            diagramView.createGraph(result)
            stackLayout.currentIndex = diagramViewIndex
            break
        default:
            print("GView(updateView): failed to display result in View")
            stackLayout.currentIndex = nullViewIndex
        }
        nodeShown = true

        if(predNode !== null){
            if(predNode.isShown)
                predNode.isShown = viewArea.checkShownFlag(predNode, this)
        }

        connectedNode.isShown = true
    }

    function removeNodeConnection(){
        if(connectedNode === null){
            return
        }
        stopTask()
        clearView()
        connectedNode.title.removeViewIndicator(backgroundColor)
        predNode = connectedNode
        connectedNode = null

        if(predNode.isShown){
            predNode.isShown = viewArea.checkShownFlag(predNode, this)
        }

        model.removeConnection()
        scheduler.stopNode(predNode.model)
    }

    function changeConnectedNode(node){
        if(connectedNode === node){
            return
        }
        removeNodeConnection()
        connectedNode = node
        connectedNode.title.addViewIndicator(backgroundColor)
        
        model.connectNode(node.model)
        scheduler.stopNode(node.model)
    }

    function clearView(){
        imageView.removeImage()
        diagramView.removeGraph(false)
        stackLayout.currentIndex = nullViewIndex
        if(connectedNode !== null){
            connectedNode.isShown = viewArea.checkShownFlag(connectedNode, this)
        }
        nodeShown = false
    }
}


