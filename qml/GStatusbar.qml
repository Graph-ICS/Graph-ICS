import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Theme 1.0

import "components/"

Item {
    id: graphics_StatusBar

    height: 148
    width: parent.width

    onVisibleChanged: {
        canvas.moveNodes(visible, 0)
    }

    TabBar {
        id: tabbar
        anchors.top: parent.top
        width: parent.width
        height: 32
        background:  Rectangle {
            width: parent.width
            height: parent.height
            color: Theme.mainColor
        }

        TabButton {
            width: contentItem.textLabel.implicitWidth + 22
            height: tabbar.height
            contentItem: GContentDelegate {
                anchors.fill: parent
                textLabel.text: "Tasks"
                state: tabbar.currentIndex == 0 ? 'hover' : 'normal'
            }
        }

//        TabButton {
//            width: contentItem.textLabel.implicitWidth + 12
//            height: tabbar.height
//            contentItem: GContentDelegate {
//                anchors.fill: parent
//                textLabel.text: "Video Controls"
//                state: tabbar.currentIndex == 1 ? 'hover' : 'normal'
//            }
//        }

        TabButton {
            width: 74
            height: tabbar.height
            contentItem: GContentDelegate {
                id: msgContentDelegate
                property bool unreadMsg: false
                anchors.fill: parent
                textLabel.text: unreadMsg ? "Messages*" : "Messages"
                state: tabbar.currentIndex == 1 ? 'hover' : 'normal'
            }
        }

        onCurrentIndexChanged: {
            if(currentIndex == 1){
                msgContentDelegate.unreadMsg = false
            }
        }
    }

    StackLayout {
        currentIndex: tabbar.currentIndex
        anchors.fill: parent
        anchors.topMargin: tabbar.height

        Item {
            id: processesTab
            Rectangle {
                anchors.fill: parent
                color: Theme.contentDelegate.color.background.hover
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 11
                    color: Theme.mainColor

                    Item {
                        id: globalControls
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 0

                        GButton {
                            id: emptyButton
                            anchors.left: parent.left
                            anchors.leftMargin: 6
                            anchors.top: parent.top
                            anchors.topMargin: 6
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 6
                            visible: parent.height != 0
                            text: "Empty Queue"
                            width: 86
                            onClicked: {
                                graphics_StatusBar.emptyQueue()
                            }
                        }

//                        GVideoControlPanel {
//                            id: videoControl
//                            anchors.left: emptyButton.right
//                            anchors.leftMargin: 12
//                            anchors.top: parent.top
//                            anchors.topMargin: 4
//                            height: 28
//                            width: 180
//                            visible: false
//                            paused: false
//                            onPlay: {
//                                workerThread.playVideo()
//                            }
//                            onPause: {
//                                workerThread.pauseVideo()
//                            }
//                            onStop: {
//                                workerThread.stopVideo()
//                            }
//                        }
                    }

                    Item{
                        id: processView
                        anchors.top: globalControls.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom

//                        anchors.topMargin: 4
                        anchors.leftMargin: 6

                        GListView {
                            id: listView

                            delegate: GStatusBarDelegate {
                                text: name
                                onRemoveTask: {
                                    workerThread.removeNodeAt(index - 1)
                                    var node = nodeQueue.splice(index, 1)
                                    node[0].isQueued = false
                                    processList.remove(index)
                                    rearrangeIndices()
                                }
                            }

                            model: ListModel {
                                id: processList
                                onCountChanged: {
                                    if(count > 0){
                                        var obj = listView.gDelegateModel.items.create(0)
                                        obj.firstElement = true
                                        globalControls.height = 32
                                    } else {
                                        globalControls.height = 0
                                    }
                                }
                            }
                        }
                    }
                    // taskTab Items
                }
            }
        } // taskTab end
//        Item {
//            id: videoControlTab
//            Rectangle {
//                anchors.fill: parent
//                color: Theme.contentDelegate.color.background.hover
//                Rectangle {
//                    anchors.fill: parent
//                    anchors.margins: 11
//                    color: Theme.mainColor
//                    GVideoControlPanel {
//                        id: videoControl2
//                        anchors.left: parent.left
//                        anchors.leftMargin: 4
//                        anchors.top: parent.top
//                        anchors.topMargin: 4
//                        height: 28
//                        width: 180
//                        visible: true
//                        onPlay: {
//                            threadManager.play()
//                            print("play")
//                        }
//                        onPause: {
//                            threadManager.pause()
//                            print("pause")
//                        }
//                        onStop: {
//                            threadManager.stop()
//                            print("stop")
//                        }
//                    }
//                }
//            }
//        } // Video Control Tab end

        Item {
            id: messagesTab
            Rectangle {
                anchors.fill: parent
                color: Theme.contentDelegate.color.background.hover
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 11
                    color: Theme.mainColor

                    Item{
                        anchors.fill: parent
                        GTextArea {
                            id: messagesTextArea
                            anchors.fill: parent

                        }
                    }
                    // messagesTab Items
                }
            }
        } // messagesTab end
    }

//    function showControlPanel() {
//        if(processList.count > 0){
//            var obj = listView.gDelegateModel.items.create(0)
//            if(obj.inputNode === "Video" || obj.inputNode === "Camera"){
//                videoControl.visible = true
//                videoControl.paused = false
//            }
//        }
//    }

    function rearrangeIndices(){
        for(var i = 0; i < processList.count; i++){
            var obj = listView.gDelegateModel.items.create(i)
            obj.index = i
        }
    }

    function emptyQueue() {
        for(var i = processList.count - 1; i > 0; i--){
            processList.remove(i)
        }
        while(nodeQueue.length > 1){
            var node = nodeQueue.pop()
            node.isQueued = false
        }
        workerThread.emptyQueue()
    }

    function queueNode(node){
        var count = processList.count
        processList.append({name: node.objectName})
        var obj = listView.gDelegateModel.items.create(count)
        obj.index = count
        obj.inputNode = node.model.getInputNodeName()

//        showControlPanel()

        workerThread.add(node.model)
    }

    function dequeueNode(){
        if(processList.count > 0)
            processList.remove(0)

        rearrangeIndices()
//        videoControl.visible = false
//        showControlPanel()
    }

    function printMessage(message){
        messagesTextArea.append(message)
        if(tabbar.currentIndex != 1){
            msgContentDelegate.unreadMsg = true
        }
    }
}
