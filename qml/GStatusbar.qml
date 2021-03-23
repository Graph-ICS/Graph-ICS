import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Theme 1.0

import "components/"

Item {
    id: graphics_StatusBar

    height: 148
    width: parent.width
    property int minWidth: row.width + tabMargin*2
    property int minHeight: globalControls.height + tabbar.height + 20
    property int tabMargin: 11
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
            id: tasksButton
            width: contentItem.textLabel.implicitWidth + 22
            height: tabbar.height
            contentItem: GContentDelegate {
                anchors.fill: parent
                textLabel.text: "Tasks"
                state: tabbar.currentIndex == 0 ? 'hover' : 'normal'
            }
        }

        TabButton {
            id: messagesButton
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
                    anchors.margins: tabMargin
                    color: Theme.mainColor

                    Item {
                        id: globalControls
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 32
                        property bool showEmptyQueue: false
                        property bool showVideoControls: false
                        Row {
                            id: row
                            spacing: 12
                            leftPadding: 4
                            topPadding: 4

                            height: parent.height
                            width: childrenRect.width + leftPadding*2

                            GButton {
                                id: processButton
                                toolTip.text: "Start all nodes that are connected to a view"
                                text: "Start all"
                                width: 76
                                height: 22
                                onClicked: {
                                    forceActiveFocus()
                                    var nodes = viewArea.getAllConnectedNodes()
                                    var filteredNodes = []
                                    var models = []
                                    nodes.forEach(function queueFilteredNodes(node){
                                        if(filteredNodes.indexOf(node) === -1){
                                            filteredNodes.push(node)
                                            addToQueue(node)
                                        }
                                    })
                                }
                            }

                            GVideoControlPanel {
                                id: videoControl

                                paused: false
                                height: 22
                                width: height * 2 + 8

                                playPauseButton.toolTip.text: paused ?
                                                                  "Resume all tasks" : "Suspend all tasks"
                                stopButton.toolTip.text: "Cancel all tasks"
                                property bool stopPressed: false
                                stopButton.enabled: processList.count > 0 ? !stopPressed : false

                                onPlay: {
                                    scheduler.resume()
                                    setPausedFlagInTasks(false)
                                }
                                onPause: {
                                    scheduler.suspend()
                                    setPausedFlagInTasks(true)
                                }
                                onStop: {
                                    scheduler.stop()
                                    stopPressed = true

                                    for(var i = 0; i < processList.count; i++){
                                        var obj = listView.gDelegateModel.items.create(i)
                                        obj.disableStop()
                                    }

                                }
                                anchors.verticalCenter: processButton.verticalCenter
                            }
                        }
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
                                text: model.node.title.title
                                node: model.node
                                Component.onCompleted: {
                                    videoControls.paused = videoControl.paused
                                }

                                videoControls.onPausedChanged: {
                                    checkVideoControlsPaused()
                                }
                            }

                            model: ListModel {
                                id: processList
                                onCountChanged: {
                                    if(count == 0){
                                        videoControl.stopPressed = false
                                    }
                                }
                            }
                        }
                    }
                    // taskTab Items
                }
            }
        } // taskTab end

        Item {
            id: messagesTab
            Rectangle {
                anchors.fill: parent
                color: Theme.contentDelegate.color.background.hover
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: tabMargin
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


    function setPausedFlagInTasks(flagValue){
        for(var i = 0; i < processList.count; i++){
            var obj = listView.gDelegateModel.items.create(i)
            obj.videoControls.paused = flagValue
        }
    }

    function removeTask(node){
        for(var i = 0; i < processList.count; i++){
            var obj = processList.get(i)
            if(obj.node === node){
                processList.remove(i)
                break
            }
        }
        checkVideoControlsPaused()
    }

    function checkVideoControlsPaused(){
        var pauseCounter = 0
        for(var i = 0; i < processList.count; i++){
            var obj = listView.gDelegateModel.items.create(i)
            if(obj === null){
                return
            }

            if(obj.videoControls.paused === true){
                pauseCounter++
            }
        }
        if(pauseCounter === processList.count){
            videoControl.paused = true
        }
        if(pauseCounter === 0){
            videoControl.paused = false
        }
    }

    function addToQueue(node){
        var view = viewArea.getViewForNode(node)

        if(view === null){
            printMessageForNode(node, "Please connect a view to this node to proceed (press and hold a view and drag&drop the indicator to the node)")
            return
        }
        if(node.isQueued){
            printMessageForNode(node, "Node already in the queue")
           return
        }
        node.isQueued = true
        canvas.setPipelineFlag(node, true)

        processList.append({node: node})

        scheduler.add(view.model, videoControl.paused)
    }

    function fixPipelineFlag(){
        for(var i = 0; i < processList.count; i++){
            var obj = processList.get(i)
            canvas.setPipelineFlag(obj.node, true)
        }
    }

    function printMessageForNode(node, message){
        printMessage(node.title.title + ": " + message)
    }

    function printMessage(message){
        messagesTextArea.append(message)
        var messagesTabIndex = 1
        if(tabbar.currentIndex !== messagesTabIndex){
            msgContentDelegate.unreadMsg = true
        }
    }
}
