import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.2

import "components/"
import Theme 1.0

Window {
    id: graphics_Settings

    height: 266
    width:  472
    minimumHeight: 133
    minimumWidth: 236
    maximumHeight: 576
    maximumWidth: 472
    title: "Graph-ICS - Settings"

    property var listModels: [layoutListModel, searchListModel, themeListModel]

    Component.onCompleted: {
        configManager.loadSettings()
        for(var i = 0; i < listModels.length; i++){
            for(var j = 0; j < listModels[i].count; j++){
                var obj = listModels[i].get(j)
                setOption(obj["option"], obj["value"])
            }
        }
    }

    TabBar {
        id: tabbar
        width: parent.width
        height: 40
        background:  Rectangle {
            width: graphics_Settings.width
            height: graphics_Settings.height
            color: Theme.mainColor
        }

        TabButton {
            width: 64
            height: tabbar.height
            contentItem: GContentDelegate {
                anchors.fill: parent
                textLabel.text: "Layout"
                state: tabbar.currentIndex == 0 ? 'hover' : 'normal'
            }

        }

        TabButton {
            width: 64
            height: tabbar.height
            contentItem: GContentDelegate {
                anchors.fill: parent
                textLabel.text: "Behavior"
                state: tabbar.currentIndex == 1 ? 'hover' : 'normal'
            }

        }

        TabButton {
            width: 64
            height: tabbar.height
            contentItem: GContentDelegate {
                anchors.fill: parent
                textLabel.text: "Theme"
                state: tabbar.currentIndex == 2 ? 'hover' : 'normal'
            }

        }

    }

    StackLayout {
        currentIndex: tabbar.currentIndex
        y: tabbar.height
        width: parent.width
        height: parent.height - tabbar.height

        Item {
            id: layoutTab
            Rectangle {
                anchors.fill: parent
                color: Theme.contentDelegate.color.background.hover
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 24
                    color: Theme.mainColor

                    GListView {
                        id: layoutList
                        model: ListModel {
                            id: layoutListModel
                            ListElement {
                                option: "enable Sidepanel"
                                value: true
                            }
                            ListElement {
                                option: "enable Favoritesbar"
                                value: true
                            }
                            ListElement {
                                option: "enable Statusbar"
                                value: true
                            }
                            ListElement {
                                option: "scale Image in Imageview"
                                value: false
                            }
                        }
                        delegate: GSwitchDelegate {
                            text: option
                            checked: value
                            onCheckedChanged: {
                                value = checked
                                configManager.saveSettings()
                                setOption(option, value)
                            }
                        }
                    }
                }
            }
        }

        Item {
            id: searchTab
            Rectangle {
                anchors.fill: parent
                color: Theme.contentDelegate.color.background.hover
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 24
                    color: Theme.mainColor

                    GListView {
                        id: searchList
                        model: ListModel {
                            id: searchListModel
                            ListElement {
                                option: "enable 'google-Search'"
                                value: false
                            }
                            ListElement {
                                option: "always display Node Warnings"
                                value: true
                            }

                        }
                        delegate: GSwitchDelegate {
                            text: option
                            checked: value
                            onCheckedChanged: {
                                value = checked
                                configManager.saveSettings()
                                setOption(option, value)
                            }
                        }
                    }
                }
            }
        }

        Item {
            id: themeTab
            Rectangle {
                anchors.fill: parent
                color: Theme.contentDelegate.color.background.hover
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 24
                    color: Theme.mainColor

                    GListView {
                        id: themeList
                        model: ListModel {
                            id: themeListModel
                            ListElement {
                                option: "enable darkMode (highly recommended)"
                                value: true
                            }

//                            ListElement {
//                                option: "enable colorfulMode"
//                                value: false
//                            }

                            ListElement {
                                option: "enable accent"
                                value: true
                            }
                        }
                        delegate: GSwitchDelegate {
                            text: option
                            checked: value
                            onCheckedChanged: {
                                value = checked
                                configManager.saveSettings()
                                setOption(option, value)
                            }
                        }
                    }
                }
            }
        }
    }

    function setOption(option, value){
        switch(option){
            case "enable Sidepanel":
                sidePanel.visible = value
                if(value){
                    if(!favoritesBar.visible)
                        favoritesBar.visible = true
                } else {
                    if(!favoritesBar.favoritesContainer.visible)
                        favoritesBar.visible = false
                }

                sidePanel.width = value ? sidePanelWidth : 0
                favoritesBar.searchBar.visible = value
                break

            case "enable Favoritesbar":
                favoritesBar.visible = value ? value : sidePanel.visible ? true : value
                favoritesBar.addFavorites = value
                favoritesBar.favoritesContainer.visible = value
                break

            case "scale Image in Imageview":
                imageView.state = value ? 'scale' : 'normal'
                imageView.reload()
                break

            case "enable 'google-Search'":
                sidePanel.googleSearch = value
                if(value)
                    sidePanel.listModel.clear()
                else
                    sidePanel.reload()
                break

            case "enable Statusbar":
                statusBar.visible = value
                break

            case "enable darkMode (highly recommended)":
                Theme.darkMode = value
                canvas.requestPaint()
                break

            case "enable colorfulMode":
                Theme.colorfulMode = value
                canvas.requestPaint()
                break

            case "enable accent":
                Theme.accentEnabled = value
                break

            case "always display Node Warnings":
                nodeWarning.disabled = !value
                break
        }
    }

    function setSettingsConfig(config){
        for(var i = 0; i < config.length; i++){
            listModels[i].clear()
            for(var j = 0; j < config[i].length; j++){
                listModels[i].append({"option": config[i][j]["option"], "value": config[i][j]["value"]})
            }
        }
    }

    function getSettingsConfig(){
        var result = []
        var list = []
        for(var i = 0; i < listModels.length; i++){
            for(var j = 0; j < listModels[i].count; j++){
                list.push(listModels[i].get(j))
            }
            result.push(list)
            list = []
        }

        return result
    }

}
