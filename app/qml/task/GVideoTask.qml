import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.2

import Theme 1.0
import Backend 1.0
import Global 1.0

import "../components"

GImageTask {
    id: videoTask

    signal handleSaveVideo

    readonly property int frameId: model ? model.frameId : 0
    readonly property int amountOfFrames: model ? model.amountOfFrames : 0
    readonly property int editFromFrameId: model ? model.editFromFrameId : 0
    readonly property int editToFrameId: model ? model.editToFrameId : 0
    readonly property int pastePosition: model ? model.pastePosition : 0

    readonly property bool isSavingVideo: model ? model.isSavingVideo : false
    readonly property bool isPauseState: state == VideoTask.PAUSE

    property bool isHandlingCancel: false

    property bool isGData: portType == Port.GDATA

    controlActions: [playAction, pauseAction, stopAction]
    fileActions: [saveImageAction, saveVideoAction, cancelSaveVideoAction]

    cancelAction.enabled: !isCancelRequested && !isSavingVideo

    property Action pauseAction: Action {
        text: qsTr("Pause")
        icon.source: Theme.icon.pause
        onTriggered: {
            model.pause()
        }
        enabled: model ? model.isPauseAllowed : false
    }

    property Action saveVideoAction: Action {
        text: qsTr("Save Video As")
        icon.source: Theme.icon.saveAs
        onTriggered: {
            saveVideoFileDialog.open()
        }
        enabled: model ? model.isSaveVideoAllowed : false
    }

    property Action cancelSaveVideoAction: Action {
        text: qsTr("Cancel Save Video")
        icon.source: Theme.icon.cancel
        onTriggered: {
            model.cancelSaveVideo()
        }
        enabled: model ? model.isCancelSaveVideoAllowed : false
    }

    property FileDialog saveVideoFileDialog: FileDialog {
        selectExisting: false
        folder: shortcuts.movies
        // modality: Qt.ApplicationModal
        nameFilters: model ? fileHandler.createNameFiltersFromAcceptedFiles(
                                 model.getSupportedVideoFiles(), "Video") : []
        onAccepted: {
            videoTask.outputPath = fileIO.removePathoverhead(fileUrl)
            model.saveVideoAs(outputPath)
            handleSaveVideo()
        }
    }

    property Action cutFramesAction: Action {
        text: model ? qsTr("Cut Frames from " + model.editFromFrameId + " to "
                           + model.editToFrameId) : ""
        icon.source: Theme.icon.cut
        onTriggered: model.cutFrames()
        enabled: model ? model.isCutFramesAllowed : false
    }

    property Action copyFramesAction: Action {
        text: model ? qsTr("Copy Frames from " + model.editFromFrameId + " to "
                           + model.editToFrameId) : ""
        icon.source: Theme.icon.copy
        onTriggered: model.copyFrames()
        enabled: model ? model.isCopyFramesAllowed : false
    }

    property Action pasteFramesAction: Action {
        text: model ? qsTr("Paste " + model.amountOfCopiedFrames + " Frames at "
                           + model.pastePosition) : ""
        icon.source: Theme.icon.paste
        onTriggered: model.pasteFrames()
        enabled: model ? model.isPasteFramesAllowed : false
    }

    property Action undoCommandAction: Action {
        text: qsTr("Undo")
        icon.source: Theme.icon.undo
        onTriggered: model.undoCommand()
        enabled: model ? model.isUndoAllowed : false
    }

    property Action redoCommandAction: Action {
        text: qsTr("Redo")
        icon.source: Theme.icon.redo
        onTriggered: model.redoCommand()
        enabled: model ? model.isRedoAllowed : false
    }

    property YesNoDialog yesNoDialog: YesNoDialog {
        title: qsTr("Graph-ICS - " + name)
        onActiveChanged: yesButton.highlightAnimation.running = true
        onClosing: {
            if (isCancelRequested) {
                isCancelRequested = isDecisionMade
                cancelHandled(isDecisionMade)
            }
        }
    }

    handleCancelNotAllowed: function (messageCode) {
        if (messageCode === VideoTask.UNSAVED_VIDEO) {
            if (!isSavingVideo) {
                yesNoDialog.open(qsTr("Do you want to save your Video?"),
                                 function () {
                                     videoTask.isHandlingCancel = true
                                     saveVideoAction.trigger()
                                     yesNoDialog.close()
                                 }, function () {
                                     model.cancel()
                                     yesNoDialog.close()
                                 })
            }
        }
    }

    onSaveResultFinished: {
        if (isHandlingCancel) {
            isCancelRequested = false
            isHandlingCancel = false
            if (statusCode === ImageTask.CANCELLED) {
                return
            }
            model.cancel()
        }
    }

    onIsSavingVideoChanged: {
        if (isSavingVideo) {
            Global.savingVideo()
        }
    }

    function setFrameId(frameId) {
        model.frameId = frameId
    }

    function setEditFromFrameId(frameId) {
        model.editFromFrameId = frameId
    }

    function setEditToFrameId(frameId) {
        model.editToFrameId = frameId
    }

    function setPastePosition(frameId) {
        model.pastePosition = frameId
    }

    function startSliding(startFrameId) {
        model.startSliding(startFrameId)
    }

    function endSliding(endFrameId) {
        model.endSliding(endFrameId)
    }
}
