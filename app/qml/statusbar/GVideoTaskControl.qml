import QtQuick 2.0
import QtQuick.Layouts 1.15
import QtQml 2.15

import Theme 1.0

import "../components/"

GStatusbarTaskControl {
    id: videoTaskControl

    signal openVideoEditor

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

            action: task ? task.saveVideoAction : null
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
        VideoPlayControl {
            id: playButton

            Layout.fillHeight: true
            Layout.preferredWidth: height
            Layout.maximumWidth: height
            Layout.minimumWidth: height

            task: videoTaskControl.task
            visible: task ? !task.isSavingVideo : false
        }

        VideoStopControl {
            id: stopButton

            Layout.fillHeight: true
            Layout.preferredWidth: height
            Layout.maximumWidth: height
            Layout.minimumWidth: height

            task: videoTaskControl.task
        }

        VideoFrameControl {
            id: frameSlider

            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.preferredWidth: height
            Layout.minimumWidth: height

            task: videoTaskControl.task
            visible: task ? !task.isSavingVideo : false
        }

        GProgressBar {
            id: progressBar

            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.preferredWidth: height
            Layout.minimumWidth: height

            innerText: qsTr("Saving Video...")

            from: 0
            to: task ? task.amountOfFrames !== 0 ? task.amountOfFrames - 1 : 0 : 0
            value: task ? task.frameId : 0

            visible: task ? task.isSavingVideo : false
        }

        GIconButton {
            id: editVideoButton

            Layout.fillHeight: true
            Layout.preferredWidth: height

            visible: frameSlider.visible
            enabled: task ? !task.isGData && frameSlider.enabled : false

            toolTip.text: qsTr("Edit Video")

            z: -1
            icon.source: Theme.icon.edit
            onClicked: {
                openVideoEditor()
            }
        }

        Item {
            Layout.fillWidth: !frameSlider.visible
            Layout.fillHeight: true
        }
    }
}
