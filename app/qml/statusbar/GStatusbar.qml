import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt.labs.qmlmodels 1.0

import Theme 1.0
import Global 1.0
import Backend 1.0

import "../components/"
import "../task"

Item {
    id: graphics_StatusBar

    property int minWidth: 0
    property int minHeight: tabbar.height
    property int tabMargin: Theme.marginWidth

    property int listViewItemLeftSpacing: background.getMarginWidth()
    property var editVideoTabs: []

    property int taskControlHeight: Theme.baseHeight

    visible: Global.windowSettings.statusbarEnabled

    TabBar {
        id: tabbar
        anchors.top: parent.top
        width: parent.width
        height: Theme.mediumHeight
        clip: true

        background: Rectangle {
            width: parent.width
            height: parent.height
            color: Theme.background
        }

        GTabButton {
            id: tasksButton
            anchors.bottom: parent ? parent.bottom : undefined
            height: parent ? parent.height : 0
            text: qsTr("Tasks")
            selected: true
        }

        GTabButton {
            id: messagesButton
            anchors.bottom: parent ? parent.bottom : undefined
            height: parent ? parent.height : 0
            text: qsTr("Messages")
        }
        onCurrentIndexChanged: {
            for (var i = 0; i < contentChildren.length; i++) {
                contentChildren[i].selected = false
            }
            contentChildren[currentIndex].selected = true
        }
    }

    Component {
        id: editVideoTabButtonComp
        GTabButton {
            anchors.bottom: parent ? parent.bottom : undefined
            height: parent ? parent.height : 0
            font: Theme.font.body2
            property var task: null
            closeable: true
            onClose: {
                _removeVideoEditor(task)
            }
        }
    }

    GBackground {
        id: background
        anchors.fill: parent
        anchors.topMargin: tabbar.height
    }

    StackLayout {
        id: stackLayout
        currentIndex: tabbar.currentIndex

        anchors.fill: parent
        anchors.topMargin: tabbar.height + background.getMarginWidth()
        anchors.bottomMargin: background.getMarginWidth()
        anchors.rightMargin: background.getMarginWidth()

        Item {
            id: tasksTab
            GListView {
                id: tasksListView
                anchors.fill: parent
                listView.spacing: Theme.largeSpacing

                Component.onCompleted: {
                    taskListModel.append({
                                             "taskType": "Global",
                                             "task": -1
                                         })
                }

                delegate: taskDelegateChooser

                model: ListModel {
                    id: taskListModel
                    dynamicRoles: true
                }
            }
        }

        MessageTab {
            id: messagesTab
        }

        Repeater {
            id: videoEditorRepeater
            model: ListModel {}
            GListView {
                Component.onCompleted: {
                    model.append({
                                     "task": task
                                 })
                }
                anchors.fill: undefined
                model: ListModel {}
                delegate: VideoEditor {
                    anchors.left: parent.left
                    anchors.leftMargin: background.getMarginWidth()
                    anchors.right: parent.right
                    anchors.rightMargin: background.getMarginWidth()
                    task: model.task
                }
            }
        }
    }

    DelegateChooser {
        id: taskDelegateChooser
        role: "taskType"
        choices: [
            DelegateChoice {
                roleValue: "Global"
                delegate: GGlobalTaskControl {
                    listModel: taskListModel
                    leftPadding: listViewItemLeftSpacing + 1
                    height: Theme.baseHeight
                }
            },
            DelegateChoice {
                roleValue: "Image"
                delegate: GImageTaskControl {
                    anchors.leftMargin: listViewItemLeftSpacing
                    anchors.right: parent ? parent.right : undefined
                    anchors.left: parent ? parent.left : undefined
                    height: taskControlHeight

                    task: model.task
                }
            },
            DelegateChoice {
                roleValue: "Video"
                delegate: GVideoTaskControl {
                    id: videoTaskDelegate
                    anchors.leftMargin: listViewItemLeftSpacing
                    anchors.right: parent ? parent.right : undefined
                    anchors.left: parent ? parent.left : undefined
                    height: taskControlHeight

                    task: model.task

                    onOpenVideoEditor: _createVideoEditor(task)
                }
            },
            DelegateChoice {
                roleValue: "Camera"
                delegate: GCameraTaskControl {
                    id: cameraTaskDelegate
                    anchors.leftMargin: listViewItemLeftSpacing
                    anchors.right: parent ? parent.right : undefined
                    anchors.left: parent ? parent.left : undefined
                    height: taskControlHeight

                    task: model.task

                    onOpenVideoEditor: _createVideoEditor(task)
                }
            }
        ]
    }

    function createTaskControl(task, taskColor) {
        tabbar.currentIndex = 0

        let listIndex = tasksListView.model.count
        tasksListView.model.append({
                                       "taskType": task.type,
                                       "task": task
                                   })
        let taskControl = tasksListView.gDelegateModel.items.create(listIndex)
        taskControl.taskColor = taskColor
    }

    function removeTaskControl(task) {
        for (var i = 0; i < taskListModel.count; i++) {
            let item = taskListModel.get(i)
            if (item.task === task) {
                taskListModel.remove(i)
                break
            }
        }
        // remove video editor if one is open
        _removeVideoEditor(task)
    }

    function printMessage(message) {
        messagesTab.printWarning(message)
        tabbar.currentIndex = 1
    }

    function _createVideoEditor(task) {
        for (var i = 0; i < editVideoTabs.length; i++) {
            if (editVideoTabs[i].task === task) {
                tabbar.currentIndex = editVideoTabs[i].repeaterIndex + 2
                return
            }
        }

        var tabButton = editVideoTabButtonComp.createObject(tabbar, {
                                                                "text": task.name,
                                                                "task": task
                                                            })
        tabbar.addItem(tabButton)

        videoEditorRepeater.model.append({
                                             "task": task
                                         })

        editVideoTabs.push({
                               "task": task,
                               "tabButton": tabButton,
                               "repeaterIndex": videoEditorRepeater.model.count - 1
                           })

        tabbar.currentIndex = videoEditorRepeater.model.count + 1
    }

    function _removeVideoEditor(task) {
        let editVideoTab = null
        for (var i = 0; i < editVideoTabs.length; i++) {
            let item = editVideoTabs[i]
            if (item.task === task) {
                editVideoTab = item
                break
            }
        }
        if (editVideoTab == null) {
            return
        }

        tabbar.removeItem(editVideoTab.tabButton)
        videoEditorRepeater.model.remove(editVideoTab.repeaterIndex)

        let repeaterIndex = editVideoTab.repeaterIndex

        editVideoTabs.forEach(function (item) {
            if (item.repeaterIndex > repeaterIndex) {
                item.repeaterIndex--
            }
        })

        editVideoTabs.splice(editVideoTabs.indexOf(editVideoTab), 1)
    }
}
