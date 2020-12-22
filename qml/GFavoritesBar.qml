import QtQuick 2.0

import QtQuick.Controls 2.15 as QQC2
import QtQuick.Controls 2.0
import QtQml.Models 2.15
import QtQuick.Layouts 1.3

import Theme 1.0

import "components/"

Item{
    id: favoritesBar
    width: parent.width
    height: visible ? 40 : 0
    property alias searchBar: searchBar
    property alias search: textField
    property alias favoritesContainer: favoriteItems
    property bool addFavorites: true

    onVisibleChanged: {
        canvas.moveNodes(visible, 40)
    }

    DropArea {
        anchors.fill: parent

        onDropped: {
            var item = drag.source.toString()

            if(item.search("GNodeAccessItem") !== -1){
                favoritesList.append({"name": drag.source.text})
            }
            configManager.saveFavoriteItems()
        }
    }

    RowLayout{
        anchors.fill: parent
        spacing: 0

        Rectangle {
            id: searchBar
            implicitWidth: sidePanel.width
            width: sidePanel.width
            color: Theme.contentDelegate.color.background.normal
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignLeft

            QQC2.TextField{
                id: textField
                anchors.centerIn: parent
                width: parent.width * 0.9
                height: parent.height * 0.7
                placeholderText: "Search"
                placeholderTextColor: Theme.contentDelegate.color.text.normal
                color: Theme.contentDelegate.color.text.press
                selectionColor: Theme.accentColor
                selectedTextColor: "white"
                font.family: Theme.font.family
                font.pointSize: Theme.font.pointSize
                maximumLength: 42
                selectByMouse: true

                background: Rectangle {
                    width: parent.width
                    height: parent.height

                    color: "transparent"

                    Rectangle {
                        anchors.bottom: parent.bottom
                        height: 1
                        width: parent.width

                        color: textField.activeFocus ? Theme.accentColor : Theme.contentDelegate.color.text.normal
                    }
                }
                cursorDelegate: Rectangle {
                    color: Theme.accentColor
                    visible: textField.activeFocus ? true : false
                    width: 1
                }
            }

        }

        Rectangle {
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignLeft
            visible: searchBar.visible
            width: 1
            color: Theme.accentEnabled ? Theme.accentColor : Theme.contentDelegate.color.background.normal
        }

        Rectangle {
            id: favoriteItems
            width: root.width - 1 - searchBar.width
            Layout.alignment: Qt.AlignLeft
            height: parent.height

            color: Theme.mainColor



            Component {
                id: dragDelegate
                GFavoritesBarItem {
                    text: name
                    container: favoriteItems
                    horizontal: true
                    thisComponent: dragDelegate
                    delegate: list.gDelegateModel
                    onSaveFavoritesConfig: {
                        configManager.saveFavoriteItems()
                    }
                    onMove: {
                        resetHeld()
                    }
                }
            }

            GListView {
                id: list
                width: parent.width
                horizontal: true
                model: ListModel {
                    id: favoritesList
                }
                delegate: dragDelegate
            }
        }
        Item {
            id: fillerItem
            Layout.fillWidth: true
        }
    }

    function resetHeld(){
        var count = getListSize()
        for(var i = 0; i < count; i++){
            var obj = list.gDelegateModel.items.create(i)
            obj.held = false
            obj.content.state = 'normal'
        }
    }

    function append(text){
        list.gDelegateModel.model.append({"name": text})
        configManager.saveFavoriteItems()
    }

    function getObjectText(index){
        var obj = list.gDelegateModel.items.create(index)
        return obj.text
    }

    function getListSize(){
        return list.gDelegateModel.items.count
    }

    function highlightFavoriteItem(itemName){
        var count = getListSize()
        for(var i = 0; i < count; i++){
            if(itemName === getObjectText(i)){
                var obj = list.gDelegateModel.items.create(i)
                obj.content.highlight.running = true
            }
        }
    }

    function isFavoriteItem(itemName){
        for(var i = 0; i < getListSize(); i++){
            var name = favoritesList.get(i)["name"]
            if(name === itemName){
                return true
            }
        }
        return false
    }

}
