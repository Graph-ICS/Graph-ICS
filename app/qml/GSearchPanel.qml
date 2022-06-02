import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml.Models 2.15

import QtQuick.Layouts 1.15

import Theme 1.0
import Global 1.0

import "components/"

Item {
    id: searchpanel

    readonly property bool searchOnType: Global.behaviorSettings.searchOnTyping

    property alias listModel: sidePanelListModel

    visible: Global.windowSettings.searchpanelEnabled

    NodeList {
        id: nodeList
        onNodesAdded: {
            reload()
        }
    }

    PropertyAnimation {
        id: sidePanel_widthAnimation
        target: searchpanel
        property: "SplitView.preferredWidth"
        from: searchpanel.width
        to: searchPanelDefaultWidth
        duration: 150
    }

    Rectangle {
        id: searchBar

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Theme.largeHeight

        color: Theme.surface

        TextField {
            id: textField

            anchors.fill: parent
            anchors.leftMargin: Theme.largeSpacing
            anchors.rightMargin: anchors.leftMargin

            placeholderText: qsTr("Search...")
            placeholderTextColor: Theme.onsurface

            color: Theme.onsurface
            selectionColor: Theme.primary
            selectedTextColor: Theme.onprimary

            font: Theme.font.body2

            maximumLength: 42
            selectByMouse: true

            onTextEdited: {
                sidePanel_widthAnimation.running = true
                if (searchpanel.searchOnType) {
                    searchpanel.search(search.text)
                }
                if (textField.text === "") {
                    searchpanel.reload()
                }
            }

            onAccepted: {
                sidePanel_widthAnimation.running = true
                if (!searchpanel.searchOnType) {
                    if (textField.text === "") {
                        searchpanel.reload()
                    } else {
                        searchpanel.search(textField.text)
                    }
                }
            }

            background: Item {
                width: parent.width
                height: parent.height

                Rectangle {
                    anchors.bottom: parent.bottom
                    height: 1
                    width: parent.width

                    color: {
                        if (textField.activeFocus) {
                            return Theme.primary
                        }
                        if (Theme.darkMode) {
                            return Qt.darker(Theme.onsurface)
                        }
                        return Qt.lighter(Theme.onsurface)
                    }
                }
            }
            cursorDelegate: Rectangle {
                color: Theme.primary
                visible: textField.activeFocus ? true : false
                width: 1
            }
        }
    }

    Rectangle {
        id: rect

        color: Theme.background
        anchors.top: searchBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Component {
            id: dragDelegate
            GNodeAccessItem {
                id: item
                text: name
                container: rect
                horizontal: false
                thisComponent: dragDelegate
                content.textLabel.horizontalAlignment: Text.AlignLeft
                content.textLabel.width: content.width - 12
                drag.target: object == null ? null : object
                drag.axis: Drag.XAndYAxis

                property var object: null

                onPressAndHold: {
                    if (favoritesBar.addFavoritesAllowed) {
                        if (mouse.button != Qt.RightButton) {
                            if (!isDragging) {
                                if (favoritesBar.isFavoriteItem(text)) {
                                    favoritesBar.highlightFavoriteItem(text)
                                    return
                                }

                                held = true
                                var component = Qt.createComponent(
                                            "components/GContentDelegate.qml")
                                object = component.createObject(root)

                                object.height = content.height
                                object.textLabel.text = text

                                if (item.content.width
                                        < item.content.textLabel.implicitWidth + 22) {
                                    object.width = item.content.textLabel.implicitWidth + 22
                                } else {
                                    if (item.content.width
                                            > item.content.textLabel.implicitWidth + 22) {
                                        object.width = item.content.textLabel.implicitWidth + 22
                                    } else {
                                        object.width = item.content.width
                                    }
                                }

                                var pos = item.getAbsolutePosition(item)
                                object.x = pos.x + mouseX - object.width / 2
                                object.y = pos.y
                                object.state = 'pressAndHold'
                                object.Drag.keys = ["Favorite"]
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
                    if (object !== null) {
                        object.Drag.drop()
                        object.destroy()
                    }
                }

                menu: GMenu {
                    GMenuItem {
                        action: item.createAndPlaceAction
                    }
                    GMenuItem {
                        action: Action {
                            text: qsTr("Add to Favorites")
                            enabled: favoritesBar.addFavoritesAllowed
                            onTriggered: {
                                favoritesBar.addToFavorites(item.text)
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
                    searchpanel.reload()
                }
            }
            delegate: dragDelegate
        }
    }

    function reload() {
        sidePanelListModel.clear()
        for (var i = 0; i < nodeList.count; i++) {
            sidePanelListModel.append(nodeList.get(i))
        }
    }

    function search(string) {
        sidePanelListModel.clear()
        var res = String(string).toLowerCase()
        for (var i = 0; i < nodeList.count; i++) {
            var obj = nodeList.get(i)
            var text = obj["name"]

            if (String(text).toLowerCase().search(res) !== -1) {
                sidePanelListModel.append(obj)
            }
        }
    }
}
