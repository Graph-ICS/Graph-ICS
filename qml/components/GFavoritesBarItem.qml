import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQml.Models 2.12


GNodeAccessItem {
    id: favoritesBarItem
    property bool itemsMovable: true
    property DelegateModel delegate: null

    drag.target: held ? content : undefined
    drag.axis: Drag.XAxis

    signal saveFavoritesConfig
    signal move

    content.states: State {
        when: favoritesBarItem.held
        PropertyChanges {
            target: favoritesBarItem.content
            color: favoritesBarItem.content.colorState.background.pressAndHold
        }
        PropertyChanges {
            target: favoritesBarItem.content.textLabel
            color: favoritesBarItem.content.colorState.text.pressAndHold
        }
        AnchorChanges {
            target: favoritesBarItem.content
            anchors {
                horizontalCenter: undefined; verticalCenter: undefined
            }
        }
        ParentChange {
            target: favoritesBarItem.content
            parent: favoritesBarItem.container
        }
    }

    onPressAndHold: {
        if(mouse.button != Qt.RightButton){
            if(!isDragging)
                move()
                held = true
        }
    }

    onReleased: {
        held = false
    }

    DropArea {
        anchors.fill: parent
        anchors.margins: 10

        onDropped: {
            var item = drag.source.toString()

            if(item.search("GNodeAccessItem") !== -1){
                favoritesBarItem.delegate.model.append({"name": drag.source.text})
                var index = favoritesBarItem.delegate.model.count - 1
                var obj = favoritesBarItem.delegate.items.create(index)
                favoritesBarItem.delegate.items.move(index, favoritesBarItem.DelegateModel.itemsIndex)
            }

            favoritesBarItem.saveFavoritesConfig()
        }

        onEntered: {
            var item = drag.source.toString()

            if(item.search("Rectangle") !== -1){
                return
            }

            if(item.search("GNodeAccessItem") === -1){

                favoritesBarItem.delegate.items.move(drag.source.DelegateModel.itemsIndex,
                                                         favoritesBarItem.DelegateModel.itemsIndex)

                favoritesBarItem.saveFavoritesConfig()
            }
        }
    }

    menu: GMenu{
        id: menu
        QQC2.Action {
            text: "Create Node"
            onTriggered: {
                favoritesBarItem.thisNode =  createNode(favoritesBarItem.text)
                favoritesBarItem.dropNode()
            }
        }

        QQC2.Action {
            text: "Move"
            onTriggered: {
                move()
                held = true
            }
        }

        QQC2.Action {
            text: "Remove from Favorites"
            onTriggered: {
                for(var i = 0; i < favoritesBarItem.delegate.model.count; i++){
                    if( favoritesBarItem.text === favoritesBarItem.delegate.model.get(i)["name"]){
                        favoritesBarItem.delegate.model.remove(i)
                        favoritesBarItem.saveFavoritesConfig()
                        return
                    }
                }
            }
        }
    }
}
