import QtQuick 2.0
import QtQuick 2.10
import QtQuick.Controls 2.4

import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

Button {
    property var node: null
    property var component: null
    property bool isDragPossible: false
    property alias label: label
    property bool insertAtEnd: false

    id: toolBarItem
    visible: true
    focus: true
    height: parent.height
    width: 100

    background: Rectangle {
        width: parent.width
        id: rect
        radius: 5
        color: "white"
        border.width: 0.5
        border.color: "grey"
    }

    Label {
        id:label
        anchors.centerIn: parent
        font.pixelSize: 12
    }

    property bool move: false


    MouseArea {
        id: mouseArea
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        anchors.fill: parent

        drag.minimumY: 0
        drag.maximumY: 0

        onPressed: {
            // um die ComboBox wieder hochzuklappen wenn man au einen Button klickt
            toolBar.toolbarCombobox.state = toolBar.toolbarCombobox.state==="";
            canvas.resetSelectedNodes(); // Knoten Markierungen entfernen
            if(mouse.button === Qt.RightButton) {
                isDragPossible = false;
            }
            if(!move) {
                if(mouse.button === Qt.LeftButton) {
                    var name = toolBarItem.label.text;
                    if (name === "Image"){
                        node = createNode(name);
                        node.scale = 0.5;
                        node.x = mouseX+toolBarItem.x-30;
                        node.y = mouseY-toolBar.height-18;
                    }
                    else{
                        node = createFilter(name);
                        node.scale = 0.5;
                        node.x = mouseX+toolBarItem.x-30;
                        node.y = mouseY-toolBar.height-18;
                    }
                    isDragPossible = true;
                    rect.border.width= 1.5;
                }
            }
        }

        onPositionChanged: {
            if(isDragPossible && !move) {
                node.x = mouseX+toolBarItem.x-30;
                node.y = mouseY-toolBar.height-18;
            }
            if (move && pressed) {
                sortToolbarItems();
            }
        }

        onReleased: {
            rect.border.width= 0.5;
            if(move) {
                toolBarItem.y = 0;
                toolBarItem.background.border.color = "grey"
                move = false;
                mouseArea.drag.target = null;
                sortToolbarItems();
            }
            else {
                if (mouse.button === Qt.RightButton && mouse.y < parent.height && parent.x < mouse.x < parent.x + parent.width) {
                    toolButtonContextMenu.popup();
                }
                else {
                    node.scale = 1;
                }

                if(isDragPossible) {
                    if(node.objectName === "Image") {
                        node.y = Math.max(mouseY-toolBar.height-18, 0);
                        node.y = Math.min(node.y, canvas.height-node.height);
                        node.x = Math.max(mouseX+toolBarItem.x-30, 0);
                        node.x = Math.min(node.x, canvas.width-node.width-node.portOut.viewPort.width);
                    }
                    else {
                        node.y = Math.max(mouseY-toolBar.height-18, 0);
                        node.y = Math.min(node.y, canvas.height-node.height);
                        node.x = Math.max(mouseX+toolBarItem.x-30, node.portOut.viewPort.width);
                        node.x = Math.min(node.x, canvas.width-node.width-node.portOut.viewPort.width);
                    }
                    node.scale = 1;
                }
            }
        }
    }

    Menu {
        id: toolButtonContextMenu
        MenuItem {
            text: "Remove From Favorites"
            onTriggered: {
                var index = toolBar.toolbarItems.indexOf(toolBarItem);
                toolBar.toolbarItems.splice(index, 1);
                toolBarItem.destroy(10);
                drawToolbarItems();
            }
        }
        MenuItem {
            text: "Move Item"
            onTriggered: {
                for( var i=0; i<toolBar.toolbarItems.length; i++) {
                    var item = toolBar.toolbarItems[i];
                    item.move = false;
                    item.background.border.color = "grey"
                }
                mouseArea.drag.target = toolBarItem;
                toolBarItem.background.border.color = "orange"
                move = true;
            }
        }
    }
    function drawToolbarItems () {
        var pos = selectButton.width+ selectButton.x+1;
        for( var i=0; i<toolBar.toolbarItems.length; i++) {
            var item = toolBar.toolbarItems[i];
            item.x = pos;
            pos = pos+item.width+1;
        }
    }
    function sortToolbarItems () {
        if(toolBar.toolbarItems.length === 1) {
            drawToolbarItems();
            return;
        }
        var index = toolBar.toolbarItems.indexOf(toolBarItem);
        toolBar.toolbarItems.splice(index, 1);
        for( var i=0; i<toolBar.toolbarItems.length; i++) {
            var item = toolBar.toolbarItems[i];
            if(item.x > toolBarItem.x) {
                var n = toolBar.toolbarItems.indexOf(item);
                toolBar.toolbarItems.splice(n, 0, toolBarItem);
                drawToolbarItems();
                return;
            }
            else {
                insertAtEnd = true;
            }
        }
        if(insertAtEnd === true) {
            toolBar.toolbarItems.push(toolBarItem); // am Ende der Liste
            drawToolbarItems();
            return;
        }
    }
}
