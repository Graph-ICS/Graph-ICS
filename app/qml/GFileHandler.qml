import QtQuick 2.0

import Model.Image 1.0

import Model.Video 1.0
import Global 1.0

Item {
    id: fileHandler

    property var acceptedImageFiles: []
    property var acceptedVideoFiles: []
    property var imageFilesNameFilters: []
    property var videoFilesNameFilters: []
    property var allSupportedFiles: []

    Component.onCompleted: {
        let imageModel = imageModelComponent.createObject(root)
        let videoModel = videoModelComponent.createObject(root)

        acceptedImageFiles = imageModel.getAcceptedFiles()
        acceptedVideoFiles = videoModel.getAcceptedFiles()

        imageModel.destroy()
        videoModel.destroy()

        allSupportedFiles = acceptedImageFiles.concat(acceptedVideoFiles)
        allSupportedFiles.push(configManager.configFileSuffix)

        imageFilesNameFilters = createNameFiltersFromAcceptedFiles(
                    acceptedImageFiles, "Image", true)
        videoFilesNameFilters = createNameFiltersFromAcceptedFiles(
                    acceptedVideoFiles, "Video", true)

        Global.imageFilesNameFilters = imageFilesNameFilters
        Global.videoFilesNameFilters = videoFilesNameFilters
    }

    Component {
        id: imageModelComponent
        ImageModel {}
    }

    Component {
        id: videoModelComponent
        VideoModel {}
    }

    function isImageFile(filePath) {
        return isFileAccepted(filePath, acceptedImageFiles)
    }

    function isVideoFile(filePath) {
        return isFileAccepted(filePath, acceptedVideoFiles)
    }

    function isConfigFile(filePath) {
        let configFileType = configManager.configFileSuffix
        return isFileAccepted(filePath, [configFileType])
    }

    function handleUnknownFile(filePath) {
        let dotIndex = filePath.lastIndexOf(".")
        let supportedFiles = allSupportedFiles.join('", "')
        if (dotIndex === -1) {
            // not a file
            Global.printUserMessage(
                        qsTr("Try to drag & drop a file (e.g. \"" + supportedFiles + "\") :)"))
            return
        }
        let unknown = filePath.slice(dotIndex, filePath.length)
        Global.printUserMessage(
                    qsTr('Files of type "' + unknown
                         + '" are not supported!<br>Supported files are "' + supportedFiles + '"'))
    }

    function isFileAccepted(filePath, acceptedFiles) {
        for (var i = 0; i < acceptedFiles.length; i++) {
            let fileType = String(acceptedFiles[i])
            if (fileType.charAt(0) !== '.') {
                fileType = '.' + fileType
            }
            if (filePath.search(
                        fileType) === filePath.length - fileType.length) {
                return true
            }
        }
        return false
    }

    function createNameFiltersFromAcceptedFiles(acceptedFiles, fileType, oneFilter) {
        let output = []

        if (acceptedFiles) {
            if (oneFilter) {
                let result = fileType + " Files ( *"
                let joiner = " *"
                acceptedFiles.forEach(function (file) {
                    if (file.charAt(0) !== '.') {
                        file = String('.').concat(file)
                    }
                    result += file + joiner
                })
                result = result.slice(0, result.length - joiner.length)
                result += " )"
                output.push(result)
            } else {
                acceptedFiles.forEach(function (file) {
                    if (file.charAt(0) !== '.') {
                        file = String('.').concat(file)
                    }
                    output.push(fileType + " Files ( *" + file + " )")
                })
            }
        }
        return output
    }
}
