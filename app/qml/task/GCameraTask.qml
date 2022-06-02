import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.2

import Theme 1.0
import Backend 1.0
import Global 1.0

import "../components"

GVideoTask {
    id: cameraTask

    readonly property bool isCamOn: model ? model.isCamOn : false

    readonly property bool isRecordState: state == CameraTask.RECORD
    readonly property bool isRecordPauseState: state == CameraTask.RECORD_PAUSE

    property bool isSavingRecord: false

    controlActions: [playAction, pauseAction, stopAction, openCameraAction, closeCameraAction, recordAction]

    cancelAction.enabled: !isCancelRequested && !isSavingVideo && !isRecordState
                          && !isRecordPauseState

    stopAction.text: {
        if (isRecordState || isRecordPauseState) {
            return qsTr("Stop Recording")
        }
        return qsTr("Stop")
    }

    pauseAction.text: {
        if (isRecordState || isRecordPauseState) {
            return qsTr("Pause Recording")
        }
        return qsTr("Pause")
    }
    pauseAction.icon.source: isRecordState ? Theme.icon.record : Theme.icon.pause

    property Action recordAction: Action {
        property string saveRecordText: qsTr("Do you want to save your recorded Video?")
        text: qsTr("Record")
        icon.source: Theme.icon.record_off
        onTriggered: {
            if (isCamOn || model.isCameraDeviceOpen()) {
                if (isRecordPauseState) {
                    model.record()
                    return
                }
                // No recording or recording got saved
                // -> recording can be discarded without permission
                if (model.isCancelAllowed()) {
                    model.clearRecordedFrames()
                    model.record()
                    yesNoDialog.close()
                } else {
                    yesNoDialog.open(saveRecordText, function () {
                        isSavingRecord = true
                        saveVideoAction.trigger()
                        yesNoDialog.close()
                    }, function () {
                        model.clearRecordedFrames()
                        model.record()
                        yesNoDialog.close()
                    })
                }
            } else {
                openCameraAction.trigger()
            }
        }
        enabled: model ? model.isRecordAllowed : false
    }

    property Action openCameraAction: Action {
        property string confirmText: qsTr("Do you want to open your Camera?")

        text: qsTr("Open Camera")
        icon.source: Theme.icon.videocam_off
        onTriggered: {
            if (model.isCameraDeviceOpen()) {
                model.openCamera()
            } else {
                yesNoDialog.open(confirmText, function () {
                    model.openCamera()
                    yesNoDialog.close()
                }, yesNoDialog.close)
            }
        }
        enabled: model ? model.isOpenCameraAllowed : false
    }

    property Action closeCameraAction: Action {
        text: qsTr("Close Camera")
        icon.source: Theme.icon.videocam
        onTriggered: {
            model.closeCamera()
        }
        enabled: model ? model.isCloseCameraAllowed : false
    }

    handleCancelNotAllowed: function (messageCode) {
        if (messageCode === CameraTask.UNSAVED_VIDEO) {
            yesNoDialog.open(recordAction.saveRecordText, function () {
                isHandlingCancel = true
                saveVideoAction.trigger()
                yesNoDialog.close()
            }, function () {
                model.cancel()
                yesNoDialog.close()
            })
        } else if (messageCode === CameraTask.IS_RECORDING_VIDEO) {
            isCancelRequested = false
        }
    }

    onSaveResultFinished: {

        //        if (isSavingRecord) {
        //            isSavingRecord = false
        //            if (statusCode === ImageTask.CANCELLED) {
        //                return
        //            }
        //            model.clearRecordedFrames()
        //            model.record()
        //            return
        //        }
    }
}
