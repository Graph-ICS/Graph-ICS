import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml.Models 2.12

import "components/"

GNodeAccessItem {
    id: favoritesBarItem
    property bool itemsMovable: true
    property DelegateModel delegate: null

    drag.target: held ? content : undefined
    drag.axis: Drag.XAxis

    signal move

    content.states: State {
        when: favoritesBarItem.held
        PropertyChanges {
            target: favoritesBarItem.content
            color: Theme.primary
        }
        PropertyChanges {
            target: favoritesBarItem.content.textLabel
            color: Theme.onprimary
        }
        AnchorChanges {
            target: favoritesBarItem.content
            anchors {
                horizontalCenter: undefined
                verticalCenter: undefined
            }
        }
        ParentChange {
            target: favoritesBarItem.content
            parent: favoritesBarItem.container
        }
    }

    onPressAndHold: {
        if (mouse.button != Qt.RightButton) {
            if (!isDragging)
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
            if (drag.source == null) {
                return
            }

            var item = drag.source.toString()

            if (item.search("GNodeAccessItem") !== -1) {
                favoritesBarItem.delegate.model.append({
                                                           "name": drag.source.text
                                                       })
                var index = favoritesBarItem.delegate.model.count - 1
                var obj = favoritesBarItem.delegate.items.create(index)
                favoritesBarItem.delegate.items.move(
                            index, favoritesBarItem.DelegateModel.itemsIndex)
            }
        }

        onEntered: {
            if (drag.source == null) {
                return
            }

            var item = drag.source.toString()

            if (item.search("Rectangle") !== -1) {
                return
            }

            if (item.search("GNodeAccessItem") === -1) {

                favoritesBarItem.delegate.items.move(
                            drag.source.DelegateModel.itemsIndex,
                            favoritesBarItem.DelegateModel.itemsIndex)
            }
        }
    }

    menu: GMenu {
        id: menu

        GMenuItem {
            action: createAndPlaceAction
        }

        GMenuItem {
            action: Action {
                text: qsTr("Move")
                onTriggered: {
                    move()
                    held = true
                }
            }
        }
        GMenuItem {
            action: Action {
                text: qsTr("Remove")
                onTriggered: {
                    for (var i = 0; i < favoritesBarItem.delegate.model.count; i++) {
                        if (favoritesBarItem.text === favoritesBarItem.delegate.model.get(
                                    i)["name"]) {
                            favoritesBarItem.delegate.model.remove(i)
                            return
                        }
                    }
                }
            }
        }
    }
}
