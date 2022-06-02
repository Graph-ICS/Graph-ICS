import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import Qt.labs.qmlmodels 1.0

import "../components/"
import Theme 1.0
import Global 1.0

Window {
    id: graphics_Settings

    height: 233
    width: 396
    minimumHeight: 133
    minimumWidth: 236
    maximumHeight: 576
    maximumWidth: 472
    title: qsTr("Graph-ICS - Settings")

    flags: Qt.Dialog
    modality: Qt.ApplicationModal
    transientParent: root

    Component.onCompleted: {
        layoutListModel.append({
                                   "option": qsTr("Enable search panel"),
                                   "value": Global.windowSettings.searchpanelEnabled
                               })
        layoutListModel.append({
                                   "option": qsTr("Enable favorites bar"),
                                   "value": Global.windowSettings.favoritesbarEnabled
                               })
        layoutListModel.append({
                                   "option": qsTr("Enable status bar"),
                                   "value": Global.windowSettings.statusbarEnabled
                               })
        behaviorListModel.append({
                                     "option": qsTr("Search on typing (slower performance)"),
                                     "value": Global.behaviorSettings.searchOnTyping
                                 })
        behaviorListModel.append({
                                     "option": qsTr("Show Find Help dialog on startup"),
                                     "value": Global.behaviorSettings.showFindHelp
                                 })
        themeListModel.append({
                                  "option": qsTr("Enable dark mode"),
                                  "value": Global.themeSettings.darkModeEnabled
                              })
        themeListModel.append({
                                  "option": qsTr("Enable accent"),
                                  "value": Global.themeSettings.accentEnabled
                              })
    }

    TabBar {
        id: tabbar
        width: parent.width
        height: Theme.mediumHeight

        background: Rectangle {
            width: parent.width
            height: parent.height
            color: Theme.background
        }

        GTabButton {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -Theme.smallSpacing
            height: parent.height
            text: "Layout"
            selected: true
        }

        GTabButton {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -Theme.smallSpacing
            height: parent.height
            text: "Behavior"
        }

        GTabButton {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -Theme.smallSpacing
            height: parent.height
            text: "Theme"
        }
        onCurrentIndexChanged: {
            for (var i = 0; i < tabbar.contentChildren.length; i++) {
                tabbar.contentChildren[i].selected = false
            }

            tabbar.contentChildren[currentIndex].selected = true
        }
    }

    GBackground {
        id: background
        anchors.fill: parent
        anchors.topMargin: tabbar.height
    }

    StackLayout {
        currentIndex: tabbar.currentIndex
        y: tabbar.height
        width: parent.width
        height: parent.height - tabbar.height

        Item {
            id: layoutTab
            GListView {
                anchors.margins: background.getMarginWidth()
                id: layoutList

                model: ListModel {
                    id: layoutListModel
                }
                delegate: GSwitchDelegate {
                    text: option
                    checked: value
                    onCheckedChanged: {
                        value = checked
                        setOption(option, value)
                    }
                }
            }
        }

        Item {
            id: behaviorTab
            GListView {
                id: behaviorList
                anchors.margins: background.getMarginWidth()
                model: ListModel {
                    id: behaviorListModel
                }
                delegate: GSwitchDelegate {
                    text: option
                    checked: value
                    onCheckedChanged: {
                        value = checked
                        setOption(option, value)
                    }
                }
            }
        }

        Item {
            id: themeTab
            GListView {
                id: themeList
                anchors.margins: background.getMarginWidth()
                model: ListModel {
                    id: themeListModel
                }
                delegate: GSwitchDelegate {
                    text: option
                    checked: value
                    onCheckedChanged: {
                        value = checked
                        setOption(option, value)
                    }
                }
            }
        }
    }

    function setOption(option, value) {
        switch (option) {
        case qsTr("Enable search panel"):
            Global.windowSettings.searchpanelEnabled = value
            break
        case qsTr("Enable favorites bar"):
            Global.windowSettings.favoritesbarEnabled = value
            break
        case qsTr("Enable status bar"):
            Global.windowSettings.statusbarEnabled = value
            break
        case qsTr("Search on typing (slower performance)"):
            Global.behaviorSettings.searchOnTyping = value
            break
        case qsTr("Show Find Help dialog on startup"):
            Global.behaviorSettings.showFindHelp = value
            break
        case qsTr("Enable dark mode"):
            Global.themeSettings.darkModeEnabled = value
            break
        case qsTr("Enable accent"):
            Global.themeSettings.accentEnabled = value
            break
        }
    }
}
