import QtQuick 2.0
import QtQuick.Layouts 1.15

import Theme 1.0

import "../components/"

GStatusbarTaskControl {
    id: imageTaskControl

    RowLayout {
        anchors.fill: parent
        spacing: Theme.smallSpacing
        GIconButton {
            id: trashButton

            Layout.fillHeight: true
            Layout.preferredWidth: height
            Layout.maximumWidth: height
            Layout.minimumWidth: height

            action: task ? task.cancelAction : null
            toolTip.text: action ? action.text : ""
        }

        GIconButton {
            id: saveAsButton
            Layout.fillHeight: true
            Layout.preferredWidth: height
            Layout.maximumWidth: height
            Layout.minimumWidth: height

            action: task ? task.saveImageAction : null
            toolTip.text: action ? action.text : ""
        }

        Rectangle {

            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumWidth: height

            Layout.preferredWidth: 180
            Layout.maximumWidth: 180
            color: "transparent"
            border.width: 1
            border.color: taskColor
            GText {
                id: taskNameText

                anchors.fill: parent

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                leftPadding: 6
                rightPadding: 6
                text: task.name
            }
        }
        GIconButton {
            id: playButton

            Layout.fillHeight: true
            Layout.preferredWidth: height
            Layout.maximumWidth: height
            Layout.minimumWidth: height

            action: task ? task.isPlayState ? task.stopAction : task.playAction : null
            toolTip.text: action ? action.text : ""
        }

        FishSpinner {
            id: loadingSpinner
            radius: Theme.baseHeight / 2
            color: Theme.secondary
            visible: task ? task.isPlayState : false
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }
}
