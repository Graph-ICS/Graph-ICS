import QtQuick 2.9
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.0
import QtQuick 2.11

import Theme 1.0
import "components/"
import "nodes/components"
import "nodes/"
//
Item {
    id: node

    width: rect.width
    height: rect.height

    property bool isCached: false
    property bool isQueued: false
    property bool isInPipeline: false

    property alias portOut: portOut

    property var inPorts: []

    property  alias rect: rect

    property int absX: x + parent.x
    property int absY: y + parent.y

    property bool isEntered: false
    property bool isSelected: false
    property bool hasPositionChanged: false

    property  var nodesToMove : []
    property bool canDistanceBeCalculated: true
    property int distanceX: 0
    property int distanceY: 0

    property int minimumX: 0
    property int maximumX: 0
    property int minimumY: 0
    property int maximumY: 0

    property bool isImageShown: false

    property NodeTitle title: null
    property var attributes: []

    GNodeBase {
        id: rect
        isShown: isImageShown

        Component.onCompleted: {
            if(title != null){
                var bounds = title.getBounds()
                if(rect.minWidth < bounds["w"])
                    rect.width = bounds["w"]

                rect.height = bounds["h"]


                if(attributes.length <= 0){
                    rect.height += 16
                } else {
                    for(var i = 0; i < attributes.length; i++){
                        var obj = attributes[i]

                        rect.height += obj.height /*+ 12 - i * 3*/ + 8

                        if(obj.width > rect.width){
                            rect.width = obj.width
                        }
                    }
                    rect.height += 3
                }
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            drag.target: node

            drag.minimumX: minimumX
            drag.minimumY: minimumY
            drag.maximumX: maximumX
            drag.maximumY: maximumY
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onPositionChanged: {
                if (pressed) {
                    canvas.update();
                    canvas.requestPaint();
                    if(isSelected === true) {
                        var currNode = node;
                        nodesToMove = [];
                        for(var i=0; i<canvas.nodes.length; i++) {
                            var nodeAtIndex = canvas.nodes[i];
                            if(nodeAtIndex.isSelected === true) {
                                nodesToMove.push(nodeAtIndex);
                            }
                        }
                        if(canDistanceBeCalculated === true) {
                            calculateDistance(currNode);
                        }
                        for (var j=0; j<nodesToMove.length; j++) {
                            var nodeToMove = nodesToMove[j];
                            nodeToMove.x = currNode.x - nodeToMove.distanceX;
                            nodeToMove.y = currNode.y - nodeToMove.distanceY;
                            canvas.update();
                            canvas.requestPaint();
                        }
                    }
                    hasPositionChanged = true; //Position des Knotens wurde verändert
                }
            }
            onEntered: {
                if(!isSelected) {
                    rect.state = 'hover'
                    isEntered = true;
                }
            }
            onExited: {
                if(!isSelected) {
                    if(pressed) {
                        rect.state = 'hover'
                        isEntered = false
                    } else {
                        resetToDefault();
                    }
                    menuManager.updateSelectedNodes();
                }
            }

            onClicked: {
                forceActiveFocus()
                if(isSelected === false && canvas.isKeyPressed === false) {
                    canvas.resetSelectedNodes();
                }
                if(isSelected == false ) {
                    rect.state = 'select'
                    isSelected = true;
                    menuManager.updateSelectedNodes();
                }
                else {
                    if(isEntered){
                        rect.state = 'hover'
                    } else {
                        resetToDefault()
                    }

                    isSelected = false;
                    menuManager.updateSelectedNodes();
                }

                if (mouse.button === Qt.RightButton)
                    contextMenu.popup()
            }
            onDoubleClicked: {
                processNode();
                isSelected = true
                rect.state = 'select'
            }

            onReleased: {
                canDistanceBeCalculated = true;
                if(hasPositionChanged === true) { //nur wenn Position des Knotens auch verändert wurde
                    menuManager.configChanged();
                }
                hasPositionChanged = false;
                if(isSelected) {
                    rect.state = 'select'
                } else {
                    if(isEntered){
                        rect.state = 'hover'
                    } else {
                        resetToDefault()
                    }
                }

            }
            onPressed: { // beim Verschieben von mehreren Knoten überprüfen ob sich diese noch im Canvas befinden
                var portDiv = 2
                if (node.isSelected === false) { // falls ein Knoten markiert wurde aber ein unmarkierter Knoten verschoben wird
                    maximumX = canvas.width - node.width - node.portOut.viewPort.width/portDiv
                    if(node.inPorts.length > 0) {
                        minimumX = node.portOut.viewPort.width/portDiv
                    } else {
                        minimumX = 0;
                    }
                    maximumY = canvas.height-node.height;
                    minimumY = 0;
                }
                else {
                    var thisPortWidth = 0
                    if(node.inPorts.length > 0){
                        thisPortWidth = node.portOut.viewPort.width/portDiv
                    }
                    // Idee:
                    // Es wird die laengste und kuerzeste Distanz in x und y Richtung aller selected nodes gesucht
                    // und zu minimumX und minimumY des pressed Nodes zugewiesen
                    var shortestX = node.x - thisPortWidth
                    var longestX = node.x + node.width + node.portOut.viewPort.width/portDiv

                    var shortestY = node.y
                    var longestY = node.y + node.height

                    for(var i = 0; i < canvas.nodes.length; i++){
                        var canvasNode = canvas.nodes[i]
                        // self wird geskipped
                        if(canvasNode !== node){
                            // nur Nodes die selected sind werden beachtet
                            if(canvasNode.isSelected){
                                var portWidth = 0
                                if(canvasNode.inPorts.length > 0){
                                    portWidth = canvasNode.portOut.viewPort.width/portDiv
                                }

                                if(shortestX > canvasNode.x - portWidth){
                                    shortestX = canvasNode.x - portWidth
                                }
                                if(longestX < canvasNode.x + canvasNode.width + canvasNode.portOut.viewPort.width/portDiv){
                                    longestX = canvasNode.x + canvasNode.width + canvasNode.portOut.viewPort.width/portDiv
                                }

                                if(shortestY > canvasNode.y){
                                    shortestY = canvasNode.y
                                }
                                if(longestY < canvasNode.y + canvasNode.height){
                                    longestY = canvasNode.y + canvasNode.height
                                }

                            }
                        }
                    }

                    if(node.x + thisPortWidth === shortestX){
                        minimumX = thisPortWidth
                    } else {
                        minimumX = node.x - shortestX
                    }

                    if(longestX === node.x + node.width + node.portOut.viewPort.width/portDiv){
                        maximumX = canvas.width - node.width - node.portOut.viewPort.width/portDiv
                    } else {
                        maximumX = node.x + (canvas.width - longestX)
                    }

                    minimumY = node.y - shortestY

                    if(longestY === node.y + node.height){
                        maximumY = canvas.height - node.height
                    } else {
                        maximumY = node.y + (canvas.height - longestY)
                    }
                }
            }

            GMenu {
                id: contextMenu
                QQC2.Action {
                    text: "Show Image"
                    onTriggered: {
                        processNode()
                    }
                }

                QQC2.Action {
                    text: "Restore Defaults"
                    onTriggered: {
                        if(!isInPipeline){
                            restoreAttributeDefaults()
                        } else {
                            statusBar.printMessage("cannot restore Attribute Defaults while in Pipeline")
                        }
                    }
                }

                QQC2.Action {
                    text: "Remove Node"
                    onTriggered: {
                        canvas.removeNode(node);
                    }
                }
            }
        }
    }

    Port {
        id: portOut
        x: parent.width - viewPort.width / 2
        y: parent.height / 2 - portOut.height/2
        viewPort.x : 0
    }

    function processNode(){
        if(!node.isQueued){
            node.isQueued = true
//            validateAttributeValues()
            queueNode(node)
        }
    }

    function restoreAttributeDefaults(){
        for(var i = 0; i < attributes.length; i++){
            attributes[i].restoreDefault()
        }
        node.model.cleanCache()
    }

//    function validateAttributeValues(){
//        for(var i = 0; i < attributes.length; i++){
//            if(typeof(attributes[i].validateValue) == 'function') {
//                attributes[i].validateValue()
//            }
//        }
//    }

    function calculateDistance(currNode) {
        for( var j=0; j<nodesToMove.length; j++) {
            var no = nodesToMove[j];
            no.distanceX = currNode.x - no.x;
            no.distanceY = currNode.y - no.y;
        }
        canDistanceBeCalculated = false;
    }
    function resetToDefault() {
        rect.state = 'normal'
    }

    function select(){
        isSelected = true
        rect.state = 'select'
    }

    function deselect(){
        isSelected = false
        rect.state = 'normal'
    }

    function saveNode(name) {
        var obj;
        obj = { x: x, y: y,
            objectName : name};
        return obj;
    }

    function updateAttributeValues(){
        for(var i = 0; i < attributes.length; i++){
            attributes[i].updateValue()
        }
    }

    function loadNode(counter) { // wird in Filtern überschrieben
    }

    function validate() { // wird in Filtern überschrieben
        return true;
    }
}
