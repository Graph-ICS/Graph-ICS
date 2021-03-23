import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Controls 2.0
import QtQml.Models 2.15

import QtQuick.Layouts 1.15
import Theme 1.0

import "components/"

// beinhaltet die NodeAccessItems in einer ListView

Item{
    id: graphics_SidePanel
    property bool searchOnType: false
    property alias listModel: sidePanelListModel


    // Instanz der NodeList
    NodeList {
        id: nodeList
    }

    Rectangle {
        id: rect

        color: Theme.mainColor
        height: parent.height
        width: parent.width

        Component {
            id: dragDelegate
            GNodeAccessItem {
                id: item
                text: name
                container: rect
                horizontal: false
                thisComponent: dragDelegate

                drag.target: object == null ? null : object
                drag.axis: Drag.XAndYAxis

                property var object: null

                onPressAndHold: {
                    if(favoritesBar.addFavorites){
                        if(mouse.button != Qt.RightButton){
                            if(!isDragging){
                                if(favoritesBar.isFavoriteItem(text)){
                                    favoritesBar.highlightFavoriteItem(text)
                                    return
                                }

                                held = true
                                var component = Qt.createComponent("components/GContentDelegate.qml")
                                object = component.createObject(root)
                                object.height = object.textLabel.font.pointSize + 32
                                object.textLabel.text = text
                                if(rect.width < object.textLabel.implicitWidth + 12){
                                    object.width = object.textLabel.implicitWidth + 12
                                } else {
                                    object.width = rect.width
                                }

                                var pos = item.getAbsolutePosition(item)
                                object.x = pos.x
                                object.y = pos.y
                                object.state = 'pressAndHold'


                                object.Drag.active = held
                                object.Drag.source = item
                                object.Drag.hotSpot.x = object.width / 2
                                object.Drag.hotSpot.y = object.height / 2
                            }
                        }
                    }
                }

                onReleased: {
                    held = false
                    if(object !== null){
                        object.Drag.drop()
                        object.destroy()
                    }
                }

                menu: GMenu {
                    QQC2.Action {
                        text: "Create Node"
                        onTriggered: {
                            item.thisNode =  createNode(item.text)
                            item.dropNode()
                        }
                    }
                    QQC2.Action {
                        text: "Add to Favorites"
                        enabled: favoritesBar.addFavorites
                        onTriggered: {
                            if(favoritesBar.isFavoriteItem(item.text)){
                                favoritesBar.highlightFavoriteItem(item.text)
                            } else {
                                favoritesBar.append(item.text)
                            }
                        }
                    }
                }
            }
        }

        GListView {
            model: ListModel {
                id: sidePanelListModel
                Component.onCompleted: {
                    graphics_SidePanel.reload()
                }
            }
            delegate: dragDelegate
        }

    }


    function reload(){
        sidePanelListModel.clear()
        for(var i = 0; i < nodeList.count; i++){
            sidePanelListModel.append(nodeList.get(i))
        }
    }

    function search(string){
        sidePanelListModel.clear()
        var res = string.toLowerCase()
        for(var i = 0; i < nodeList.count; i++){
            var obj = nodeList.get(i)
            var text = obj["name"]

            if(text.toLowerCase().search(res) !== -1){
                sidePanelListModel.append(obj)
            }
        }
    }
}







