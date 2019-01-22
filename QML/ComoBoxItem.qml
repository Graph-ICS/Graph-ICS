import QtQuick 2.0
import QtQuick.Controls 2.4

import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

Item{ // die Items die in der Combo Box
    id: comboBoxItem
    width:comboBox.width;
    height: comboBox.height;
    property bool addMenuItemEnabled: false
    property bool removeMenuItemEnabled: false
    property bool outsideComboBoxItem: false
    property var node: null

    Text {
        text: modelData
        anchors.top: parent.top;
        anchors.left: parent.left;
        anchors.margins: 5;
        font.pointSize: 10;

    }
    MouseArea {
        id: mouseArea
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        anchors.fill: parent;
        onClicked: {
            if(mouse.button === Qt.RightButton) {
                toolbarContextMenu.open();
                if(menuManager.isAddToFavoritesAllowed(modelData)) {
                    addMenuItemEnabled = true;
                    removeMenuItemEnabled = false;
                }
                else {
                    addMenuItemEnabled = false;
                    removeMenuItemEnabled = true;
                }
            }
            else {
                comboBox.state = ""
                var prevSelection = chosenItemText.text
                chosenItemText.text = modelData
                if(chosenItemText.text !== prevSelection){
                    comboBox.comboClicked();
                }
                listView.currentIndex = index;
            }
        }
        //        onPressed: {
        //            console.log("onPressed: ", modelData);
        //            canvas.resetSelectedNodes();
        //            if (modelData === "Image"){
        //                node = createNode(modelData);
        //                node.scale = 0.5;
        //                node.x = mouseX;
        //                node.y = 10;
        //            }
        //            else{
        //                node = createFilter(modelData);
        //                node.scale = 0.6;
        //                node.x = mouseX;
        //                node.y = 10;
        //            }

        //        }

        //        onPressAndHold: {
        //            console.log("pressed and hold");
        //             canvas.resetSelectedNodes(); // Knoten Markierungen entfernen
        //            console.log("filterName: ", modelData);
        //            if (modelData === "Image"){
        //                node = createNode(modelData);
        //                node.scale = 0.5;
        //                node.x = mouseX;
        //                node.y = 10;
        //            }
        //            else{
        //                node = createFilter(modelData);
        //                node.scale = 0.6;
        //                node.x = mouseX;
        //                node.y = 10;

        //            }
        //        }
        //        onPositionChanged: {
        //            console.log("onPositionChanged");
        //            if (modelData === "Image"){
        //                node = createNode(modelData);
        //                node.scale = 0.5;
        //                node.x = mouseX;
        //                node.y = 10;
        //            }
        //            else{
        //                node = createFilter(modelData);
        //                node.scale = 0.6;
        //                node.x = mouseX;
        //                node.y = 10;
        //            }
        //        }
//        onPositionChanged: {
//            if(outsideComboBoxItem === false) {
//                if(mouseX> comboBoxItem.x+comboBoxItem.width) {
//                    console.log("jezt Flag setzen");
//                    outsideComboBoxItem = true;
//                    if (modelData === "Image"){
//                        node = createNode(modelData);
//                        node.scale = 0.5;
//                        node.x = mouseX;
//                        node.y = mouseY;
//                    }
//                    else{
//                        node = createFilter(modelData);
//                        node.scale = 0.5;
//                        node.x = mouseX;
//                        node.y = mouseY;

//                    }


//                }

//            }
//        }

        //        onReleased: {
        //            console.log("onReleased");
        //            if(mouseX> comboBoxItem.x+comboBoxItem.width) {
        //                console.log("jezt, in dem Bereich");


        //            }

        //            node.y = Math.max(mouseY-toolBar.height-18, 0);
        //                  node.y = Math.min(node.y, canvas.height-node.height);
        //                  node.x = Math.max(mouseX, 0);
        //                  node.x = Math.min(node.x, canvas.width-node.width);
        //                  node.scale = 1;

    }
    Menu {
        x:mouseArea.mouseX
        id: toolbarContextMenu
        MenuItem {
            enabled: addMenuItemEnabled
            id: addMenuItem
            text: "Add To Favorites"
            onTriggered: {
                filtersLoop:
                for(var j=0; j<filters.count; j++) {

                    if(modelData === filters.get(j).name) {
                        for (var i=0; i<toolbarItems.length; i++) {
                            if(modelData === toolbarItems[i].label.text) {
                                break filtersLoop;
                            }
                        }
                        var component = Qt.createComponent("ToolBarItem.qml");
                        var item = component.createObject(comboBox);
                        item.label.text = filters.get(j).name;
                        var text = String(filters.get(j).name);
                        item.width = text.length*7.5;
                        toolbarItems.push(item);
                        item.drawToolbarItems();
                    }
                }
            }
        }
        MenuItem {
            enabled: removeMenuItemEnabled
            id: removeMenuItem
            text: "Remove from Favorites"
            onTriggered: {
                for (var i=0; i<toolbarItems.length; i++) {
                    var item = toolbarItems[i];
                    if(modelData === item.label.text){
                        var index = i;
                        break;
                    }
                }
                var itemToDestroy = toolBar.toolbarItems[index];
                toolBar.toolbarItems.splice(index, 1);
                itemToDestroy.drawToolbarItems();
                itemToDestroy.destroy(10);
            }
        }
    }
}
