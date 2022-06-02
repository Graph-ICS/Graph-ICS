import QtQuick 2.0

import QtQuick.Controls 2.15
import QtQml.Models 2.15
import QtQuick.Layouts 1.3

import Theme 1.0
import Global 1.0

import "components/"

Item {
    id: favoritesBar

    visible: Global.windowSettings.favoritesbarEnabled

    property bool addFavoritesAllowed: visible
    property alias heightAnimation: heightAnimation

    Component.onCompleted: {
        let favoriteItems = Global.windowSettings.favoritebarItems
        for (var i = 0; i < favoriteItems.length; i++) {
            favoritesList.append({
                                     "name": favoriteItems[i]
                                 })
        }
    }

    Component.onDestruction: {
        let favoriteItems = []
        for (var i = 0; i < favoritesList.count; i++) {
            favoriteItems.push(getObjectText(i))
        }
        Global.windowSettings.favoritebarItems = favoriteItems
    }

    PropertyAnimation {
        id: heightAnimation
        target: favoritesBar
        property: "SplitView.preferredHeight"
        from: favoritesBar.height
        to: Theme.largeHeight
        duration: 150
    }

    DropArea {
        anchors.fill: parent
        keys: ["Favorite"]
        onDropped: {
            var item = drag.source.toString()
            favoritesList.append({
                                     "name": drag.source.text
                                 })
        }
    }

    Rectangle {
        id: favoriteItems
        visible: favoritesBar.visible

        width: parent.width
        height: parent.height
        color: Theme.background

        Component {
            id: dragDelegate
            GFavoritesBarItem {
                text: name
                container: favoriteItems
                horizontal: true
                thisComponent: dragDelegate
                delegate: list.gDelegateModel
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

    function addToFavorites(name) {
        if (isFavoriteItem(name)) {
            highlightFavoriteItem(name)
        } else {
            append(name)
        }
    }

    function resetHeld() {
        var count = getListSize()
        for (var i = 0; i < count; i++) {
            var obj = list.gDelegateModel.items.create(i)
            obj.held = false
            obj.content.state = 'normal'
        }
    }

    function append(text) {
        favoritesList.append({
                                 "name": text
                             })
    }

    function getObjectText(index) {
        var obj = list.gDelegateModel.items.create(index)
        return obj.text
    }

    function getListSize() {
        return list.gDelegateModel.items.count
    }

    function highlightFavoriteItem(itemName) {
        var count = getListSize()
        for (var i = 0; i < count; i++) {
            if (itemName === getObjectText(i)) {
                var obj = list.gDelegateModel.items.create(i)
                obj.content.highlight.running = true
            }
        }
    }

    function isFavoriteItem(itemName) {
        for (var i = 0; i < getListSize(); i++) {
            var name = favoritesList.get(i)["name"]
            if (name === itemName) {
                return true
            }
        }
        return false
    }
}
