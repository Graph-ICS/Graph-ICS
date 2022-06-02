import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.0
import QtQml 2.15

import Theme 1.0

import "../components/"

GStatusbarTaskControl {
    id: videoEditor

    height: column.height

    Column {
        id: column
        spacing: 12
        anchors.left: parent.left
        anchors.right: parent.right

        Row {
            spacing: Theme.largeSpacing
            height: Theme.baseHeight

            Row {
                spacing: Theme.smallSpacing
                height: Theme.baseHeight

                VideoPlayControl {
                    id: playButton
                    height: parent.height
                    width: height

                    task: videoEditor.task
                }

                VideoStopControl {
                    id: stopButton
                    height: parent.height
                    width: height

                    task: videoEditor.task
                }
            }
            Row {
                spacing: Theme.smallSpacing
                height: Theme.baseHeight

                GIconButton {
                    id: undoButton
                    height: parent.height
                    width: height

                    action: task ? task.undoCommandAction : undefined
                    toolTip.text: action.text
                }

                GIconButton {
                    id: redoButton
                    height: parent.height
                    width: height

                    action: task ? task.redoCommandAction : undefined
                    toolTip.text: action.text
                }

                GIconButton {
                    id: cutButton
                    height: parent.height
                    width: height

                    action: task ? task.cutFramesAction : undefined
                    toolTip.text: action.text
                }

                GIconButton {
                    id: copyButton
                    height: parent.height
                    width: height

                    action: task ? task.copyFramesAction : undefined
                    toolTip.text: action.text
                }

                GIconButton {
                    id: pasteButton
                    height: parent.height
                    width: height

                    action: task ? task.pasteFramesAction : undefined
                    toolTip.text: action.text
                }
            }
        }

        Item {
            id: sliders
            height: childrenRect.height

            anchors.left: parent.left
            anchors.right: parent.right

            property int toValue: frameSlider.to

            property bool isEditorSliderSliding: false
            property int frameSliderValue

            function editorSliderValueChange(pressed, value) {
                if (isEditorSliderSliding) {
                    if (pressed) {
                        task.setFrameId(value)
                    }
                }
            }
            function editorSliderPressedChange(pressed, value) {
                if (pressed) {
                    if (task.isPauseState || task.isStopState) {
                        isEditorSliderSliding = true

                        frameSliderValue = frameSlider.value
                        // remove frameSlider.value binding
                        frameSlider.value = frameSliderValue

                        task.startSliding(value)
                    }
                } else {
                    if (isEditorSliderSliding) {
                        isEditorSliderSliding = false
                        // establish frameSlider.value binding
                        frameSlider.value = Qt.binding(function () {
                            return task.frameId
                        })

                        task.endSliding(frameSliderValue)
                    }
                }
            }

            GVideoFrameMarker {
                id: frameMarker
                z: frameSlider.z - 2

                anchors.left: parent.left
                anchors.right: parent.right

                from: 0
                to: sliders.toValue
                value: task.pastePosition
                height: markerHeight
                markerHeight: 50

                onValueChanged: {
                    sliders.editorSliderValueChange(pressed, value)
                }

                onPressedChanged: {
                    sliders.editorSliderPressedChange(pressed, value)
                    if (!pressed) {
                        task.setPastePosition(value)
                    }
                }

                GToolTip {
                    text: task.pasteFramesAction.text
                    parent: frameMarker.handle
                    visible: frameMarker.hovered && !frameMarker.pressed
                             && text != ""
                }
            }

            VideoFrameControl {
                id: frameSlider
                anchors.top: frameMarker.bottom
                anchors.left: parent.left
                anchors.right: parent.right

                task: videoEditor.task

                toIndicator.visible: false

                Rectangle {
                    z: -1
                    x: rangeMarker.x
                    width: rangeMarker.width
                    anchors.top: parent.background.top
                    anchors.bottom: parent.background.bottom
                    color: Theme.secondary
                    opacity: 0.7
                }

                Rectangle {
                    z: -1
                    x: frameMarker.markerLine.x + frameMarker.handle.x
                    anchors.top: parent.background.top
                    anchors.bottom: parent.background.bottom
                    color: frameMarker.handleColor
                    width: frameMarker.markerLine.width
                }
            }

            GRangeSlider {
                id: frameRange
                z: frameSlider.z - 1

                snapMode: Slider.SnapAlways

                anchors.top: frameSlider.bottom
                anchors.left: parent.left
                anchors.right: parent.right

                firstToolTip.text: task.cutFramesAction.text
                secondToolTip.text: task.cutFramesAction.text

                rangeColor: Theme.secondary

                from: 0
                to: sliders.toValue

                first.value: task.editFromFrameId
                second.value: task.editToFrameId

                first.onValueChanged: {
                    sliders.editorSliderValueChange(first.pressed, first.value)
                }

                second.onValueChanged: {
                    sliders.editorSliderValueChange(second.pressed,
                                                    second.value)
                }

                first.onPressedChanged: {
                    sliders.editorSliderPressedChange(first.pressed,
                                                      first.value)
                    if (!first.pressed) {
                        task.setEditFromFrameId(first.value)
                    }
                }

                second.onPressedChanged: {
                    sliders.editorSliderPressedChange(second.pressed,
                                                      second.value)
                    if (!second.pressed) {
                        task.setEditToFrameId(second.value)
                    }
                }

                Rectangle {
                    id: rangeMarker
                    z: -3
                    anchors.left: frameRange.first.handle.horizontalCenter
                    anchors.right: frameRange.second.handle.horizontalCenter

                    anchors.bottom: frameRange.background.top
                    height: frameRange.height

                    color: Theme.secondary
                    opacity: 0.4
                }

                Rectangle {
                    z: -1
                    x: frameMarker.markerLine.x + frameMarker.handle.x
                    height: frameRange.height + frameRange.background.height
                    anchors.bottom: frameRange.background.bottom
                    color: frameMarker.handleColor
                    width: frameMarker.markerLine.width
                }
            }
        }
    }
}
