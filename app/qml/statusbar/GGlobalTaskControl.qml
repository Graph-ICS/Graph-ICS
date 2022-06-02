import QtQuick 2.15

import Theme 1.0

import "../components"

Row {
    property var listModel: null
    spacing: Theme.smallSpacing
    GIconButton {
        icon.source: Theme.icon.trash
        height: parent.height
        width: height
        enabled: listModel.count > 1
        toolTip.text: qsTr("Cancel all Tasks")
        onClicked: {
            for (var i = 1; i < listModel.count; i++) {
                let item = listModel.get(i)
                item.task.cancelAction.trigger()
            }
        }
    }
    GIconButton {
        icon.source: Theme.icon.play
        height: parent.height
        width: height
        enabled: listModel.count > 1
        toolTip.text: qsTr("Play all Tasks")
        onClicked: {
            for (var i = 1; i < listModel.count; i++) {
                let item = listModel.get(i)
                item.task.playAction.trigger()
            }
        }
    }
    GIconButton {
        icon.source: Theme.icon.pause
        height: parent.height
        width: height
        enabled: listModel.count > 1
        toolTip.text: qsTr("Pause all Tasks")
        onClicked: {
            for (var i = 1; i < listModel.count; i++) {
                let item = listModel.get(i)
                let task = item.task
                if (task.pauseAction) {
                    task.pauseAction.trigger()
                }
            }
        }
    }
    GIconButton {
        icon.source: Theme.icon.stop
        height: parent.height
        width: height
        enabled: listModel.count > 1
        toolTip.text: qsTr("Stop all Tasks")
        onClicked: {
            for (var i = 1; i < listModel.count; i++) {
                let item = listModel.get(i)
                item.task.stopAction.trigger()
            }
        }
    }
}
