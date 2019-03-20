import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.0
import QtQuick 2.11

Item {
    id: node
    width: 75
    height: 70

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
    property int maximuxY: 0

    Rectangle {
        id: rect
        //color: "steelblue"
        color: "#507893"
        anchors.fill: parent
        focus: true
        radius: 7
        border.width: 1.5
        border.color: Qt.darker(rect.color)

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            drag.target: node

            drag.minimumX: minimumX
            drag.minimumY: minimumY
            drag.maximumX: maximumX
            drag.maximumY: maximuxY
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
                parent.border.width = 2;
                parent.border.color = "orange";
                isEntered = true;
                }
            }
            onExited: {
                if(!isSelected) {
                   resetToDefault();
                    isSelected = false;
                    menuManager.updateSelectedNodes();
                }
            }
            onClicked: {
                if(isSelected === false && canvas.isKeyPressed === false) {
                    canvas.resetSelectedNodes();
                }
                if(isSelected == false ) {
                    parent.border.width = 2;
                    parent.border.color = canvas.selectColor;
                    isSelected = true;
                    menuManager.updateSelectedNodes();
                }
                else {
                    resetToDefault();
                    isSelected = false;
                    menuManager.updateSelectedNodes();
                }

                if (mouse.button === Qt.RightButton)
                    contextMenu.popup()
            }
            onDoubleClicked: {
                gImageProvider.img = node.model.getResult(); // diese Funktion müsste für das Multithreading ausgelagert werden
                root.splitView.imageView.reload();
            }
            onReleased: {
                canDistanceBeCalculated = true;
                if(hasPositionChanged === true) { //nur wenn Position des Knotens auch verändert wurde
                    menuManager.configChanged();
                }
                hasPositionChanged = false;
            }
            onPressed: { // beim Verschieben von mehreren Knoten überprüfen ob sich diese noch im Canvas befinden
                var disMinX = node.x;
                var disMaxX = node.x;
                var disMinY = node.y;
                var disMaxY = node.y;
                var nodeLongestDistanceMinX = node;
                var nodeLongestDistanceMaxX = node;
                var nodeLongestDistanceMaxY = node;
                for (var j=0; j<canvas.nodes.length; j++) {
                    var no = canvas.nodes[j];
                    if (no.isSelected === true) {
                        var difMinX = disMinX;
                        var difMaxX = disMaxX;
                        var difMaxY = disMaxY;
                        disMinX = Math.min(disMinX, no.x);
                        disMaxX = Math.max(disMaxX, no.x);
                        disMinY = Math.min(disMinY, no.y);
                        disMaxY = Math.max(disMaxY, no.y);
                        if(difMinX !== disMinX) {
                             nodeLongestDistanceMinX = no;
                        }
                        if(difMaxX !== disMaxX) {
                            nodeLongestDistanceMaxX = no;
                        }
                        if(difMaxY !== disMaxY) {
                            nodeLongestDistanceMaxY = no;
                        }
                    }
                    if(nodeLongestDistanceMinX.objectName === "Image") {
                        minimumX = node.x-disMinX;
                    }
                    else
                    minimumX = node.x-disMinX+node.portOut.viewPort.width;

                    maximumX = canvas.width - nodeLongestDistanceMaxX.width - portOut.viewPort.width-(disMaxX-node.x);
                    minimumY = node.y - disMinY;
                    maximuxY = canvas.height - nodeLongestDistanceMaxY.height-(disMaxY-node.y);
                }
            }
            Keys.onDeletePressed: {
                console.log("delete pressed");
            }

            Menu {
                id: contextMenu
                MenuItem {
                    text: "Show Image"
                    onTriggered: {
                            gImageProvider.img = node.model.getResult();
                            root.splitView.imageView.reload();
                    }
                }
                MenuItem {
                    text: "Remove Node"
                    onTriggered: {
                        node.parent.removeNode(node);
                    }
                }
            }
        }
    }

    Port {
        id: portOut
        x: parent.width
        viewPort.x : 0
    }
    function calculateDistance(currNode) {
        for( var j=0; j<nodesToMove.length; j++) {
            var no = nodesToMove[j];
            no.distanceX = currNode.x - no.x;
            no.distanceY = currNode.y - no.y;
        }
        canDistanceBeCalculated = false;
    }
    function resetToDefault() {
        rect.border.width = 1.5;
        rect.border.color = Qt.darker(rect.color);
    }

    function saveNode(name) {
        var obj;
        obj = { x: x, y: y,
        objectName : name};
        return obj;
    }
    function loadNode(counter) {
    }
}
