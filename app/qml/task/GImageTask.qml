import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.2

import Theme 1.0
import Backend 1.0
import Global 1.0

import "../components/"

GTask {
    id: imageTask

    property bool resultDisplayed: false

    readonly property int state: model ? model.state : 0
    readonly property bool isPlayState: state == ImageTask.PLAY
    readonly property bool isStopState: state == ImageTask.STOP

    property var controlActions: [playAction, stopAction]
    property var fileActions: [saveImageAction]

    signal saveResultFinished(int statusCode)

    property Action playAction: Action {
        text: qsTr("Play")
        icon.source: Theme.icon.play
        onTriggered: model.play()
        enabled: model ? model.isPlayAllowed : false
    }

    property Action stopAction: Action {
        text: qsTr("Stop")
        icon.source: Theme.icon.stop
        onTriggered: model.stop()
        enabled: model ? model.isStopAllowed : false
    }

    property Action saveImageAction: Action {
        text: qsTr("Save Image As")
        icon.source: Theme.icon.saveAs
        onTriggered: saveImageFileDialog.open()
        enabled: model ? resultDisplayed && model.isSuspended : false
    }

    property string outputPath
    property FileDialog saveImageFileDialog: FileDialog {
        selectExisting: false
        folder: shortcuts.pictures
        nameFilters: model ? fileHandler.createNameFiltersFromAcceptedFiles(
                                 model.getSupportedImageFiles(), "Image") : []
        onAccepted: {
            outputPath = fileIO.removePathoverhead(fileUrl)
            model.saveImageAs(outputPath)
        }
    }

    property var handleSaveResultAsFinished: function (statusCode) {
        switch (statusCode) {
        case ImageTask.SUCCESSED:
            Global.printUserMessage(qsTr(outputPath + " saved successfully :)"))
            break
        case ImageTask.FILE_NOT_SUPPORTED:
            let supportedImageFiles = model.getSupportedImageFiles()
            let allSupportedFiles = supportedImageFiles.concat(
                    model.getSupportedVideoFiles())
            allSupportedFiles = allSupportedFiles.join('", "')

            Global.printUserMessage(
                        qsTr(outputPath
                             + " failed to save! File not supported! Supported files are \"")
                        + allSupportedFiles + "\"")
            break
        case ImageTask.EMPTY_RESULT:
            Global.printUserMessage(
                        qsTr(outputPath + " failed to save! Nothing to save!"))
            break
        case ImageTask.WRITER_ERROR:
            Global.printUserMessage(
                        qsTr(outputPath + " failed to save! File writer encountered an error!"))
            break
        case ImageTask.CANCELLED:
            Global.printUserMessage(qsTr(outputPath + " saving cancelled!"))
            break
        }
        outputPath = ""
        saveResultFinished(statusCode)
    }

    function addControlActionsToMenu(menu) {
        while (menu.count > 0) {
            menu.takeAction(0)
        }
        controlActions.forEach(function (action) {
            menu.addAction(action)
        })
    }

    Connections {
        target: model ? model : null
        ignoreUnknownSignals: true
        function onSaveResultAsFinished(statusCode) {
            handleSaveResultAsFinished(statusCode)
        }
    }
}
