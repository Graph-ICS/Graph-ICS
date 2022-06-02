import QtQuick 2.0
import QtQuick.Layouts 1.15
import QtQml 2.15

import Theme 1.0

import "../components/"

GStatusbarTaskControl {
    id: cameraTaskControl

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
            toolTip.text: action.text
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
        GIconButton {
            id: camButton

            Layout.fillHeight: true
            Layout.preferredWidth: height
            Layout.maximumWidth: height
            Layout.minimumWidth: height

            action: task ? task.isCamOn ? task.closeCameraAction : task.openCameraAction : undefined
            toolTip.text: action ? action.text : ""

            visible: task ? !task.isSavingVideo : false
        }
        GIconButton {
            id: recordButton

            Layout.fillHeight: true
            Layout.preferredWidth: height
            Layout.maximumWidth: height
            Layout.minimumWidth: height

            action: task ? task.isRecordState ? task.pauseAction : task.recordAction : undefined
            toolTip.text: action.text
            visible: task ? !task.isSavingVideo : false
        }
        VideoPlayControl {
            id: playButton

            Layout.fillHeight: true
            Layout.preferredWidth: height
            Layout.maximumWidth: height
            Layout.minimumWidth: height

            task: cameraTaskControl.task
            visible: task ? !task.isSavingVideo : false
        }
        VideoStopControl {
            id: stopButton

            Layout.fillHeight: true
            Layout.preferredWidth: height
            Layout.maximumWidth: height
            Layout.minimumWidth: height

            task: cameraTaskControl.task
        }

        VideoFrameControl {
            id: frameSlider

            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.preferredWidth: height
            Layout.minimumWidth: height

            task: cameraTaskControl.task
            Binding on to {
                when: task ? task.isRecordState | task.isRecordPauseState : false
                value: task ? task.frameId : 0
                restoreMode: Binding.RestoreBindingOrValue
            }
            Binding on value {
                when: task ? task.isRecordState | task.isRecordPauseState : false
                value: frameSlider.to
                restoreMode: Binding.RestoreBindingOrValue
            }

            visible: task ? !task.isSavingVideo & to > 0 : false
            enabled: task ? !task.isSavingVideo & !task.isRecordState
                            & !task.isRecordPauseState : false
        }

        GProgressBar {
            id: progressBar
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.preferredWidth: 24
            Layout.minimumWidth: 24

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
            Layout.maximumWidth: height
            Layout.minimumWidth: height

            visible: frameSlider.visible
            enabled: task ? !task.isGData && frameSlider.enabled : false

            toolTip.text: "Edit Video"

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
