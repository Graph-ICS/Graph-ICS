import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3

import Theme 1.0
import Global 1.0

import "components"

Item {
    id: configManager

    readonly property string configFileSuffix: ".gconfig"

    readonly property string configFile: {
        let buf = internal.configFileUrl.split("/")
        if (buf.length > 0) {
            return buf[buf.length - 1]
        } else {
            return ""
        }
    }

    property bool isConfigChanged: false
    readonly property bool isConfigSet: configFile != ""

    property var configSavedCallback: null
    property var configClearedCallback: null

    property Action newAction: Action {
        text: qsTr("New")
        shortcut: "Ctrl+N"
        onTriggered: {
            if (isConfigChanged) {
                saveConfigWarning.yesCallback = () => {
                    saveConfigWarning.close()
                    configSavedCallback = clearConfig
                    if (isConfigSet) {
                        saveAction.trigger()
                    } else {
                        saveAsAction.trigger()
                    }
                }
                saveConfigWarning.noCallback = function () {
                    saveConfigWarning.close()
                    clearConfig()
                }
                saveConfigWarning.showNormal()
            } else {
                if (isConfigSet) {
                    clearConfig()
                } else if (configClearedCallback) {
                    configClearedCallback()
                    configClearedCallback = null
                }
            }
        }
    }

    property Action openAction: Action {
        text: qsTr("Open...")
        shortcut: "Ctrl+O"
        onTriggered: {
            internal.isHandlingOpenConfig = true
            configClearedCallback = () => {
                internal.isHandlingOpenConfig = false
                fileDialog.acceptedCallback = openConfig
                fileDialog.openFile()
            }
            newAction.trigger()
        }
        enabled: !internal.isHandlingOpenConfig
    }

    property Action saveAction: Action {
        text: qsTr("Save")
        shortcut: isConfigSet ? "Ctrl+S" : ""
        onTriggered: {
            if (isConfigSet) {
                saveConfig(internal.configFileUrl)
            } else {
                fileDialog.acceptedCallback = saveConfig
                fileDialog.saveFile()
            }
        }
        enabled: isConfigSet && isConfigChanged
    }

    property Action saveAsAction: Action {
        text: qsTr("Save As...")
        shortcut: isConfigSet ? "" : "Ctrl+S"
        onTriggered: {
            fileDialog.acceptedCallback = saveConfig
            fileDialog.saveFile()
        }
        enabled: isConfigSet ? true : isConfigChanged
    }

    YesNoDialog {
        id: saveConfigWarning
        title: qsTr("Graph-ICS - Configuration Warning")
        text: qsTr("Do you want to save your Configuration?")

        onActiveChanged: yesButton.highlightAnimation.running = true
    }

    FileDialog {
        id: fileDialog
        property var acceptedCallback: function (url) {}

        folder: shortcuts.home
        nameFilters: [qsTr(
                "Graph-ICS Config Files (*" + configFileSuffix + ")")]

        onAccepted: {
            acceptedCallback(fileUrl)
        }

        function openFile() {
            selectExisting = true
            open()
        }

        function saveFile() {
            selectExisting = false
            open()
        }
    }

    function saveConfig(fileUrl) {
        internal.saveConfigFile(fileUrl)
        isConfigChanged = false

        Global.printUserMessage(qsTr('Saved ') + configFile + '')

        if (configSavedCallback) {
            configSavedCallback()
            configSavedCallback = null
        }
    }

    function openConfig(fileUrl) {
        internal.openConfigFile(fileUrl)
        isConfigChanged = false

        Global.printUserMessage(qsTr('Opened ') + configFile + '')
    }

    function clearConfig() {
        canvas.requestClear(() => {
                                if (configClearedCallback) {
                                    configClearedCallback()
                                    configClearedCallback = null
                                }
                            })
    }

    function configChanged() {
        isConfigChanged = true
    }

    Connections {
        target: canvas
        function onNodeAdded(node) {
            isConfigChanged = true
        }
        function onNodeRemoved(node) {
            let isCleared = canvas.nodes.length == 0
            if (isCleared) {
                isConfigChanged = false
                internal.configFileUrl = ""
                Global.printUserMessage(qsTr("Config cleared!"))
            } else {
                isConfigChanged = true
            }
        }
        function onEdgeAdded(edge) {
            isConfigChanged = true
        }
        function onEdgeRemoved(edge) {
            isConfigChanged = true
        }
    }

    function clearCallback() {
        if (internal.isHandlingOpenConfig) {
            internal.isHandlingOpenConfig = false
            configClearedCallback = null
        }
    }

    Connections {
        target: Global
        function onSavingVideo() {
            clearCallback()
        }
        function onNodeDisconnectViewFailed(node) {
            clearCallback()
        }
    }

    QtObject {
        id: internal
        property string configFileUrl: ""
        property bool isHandlingOpenConfig: false

        function saveConfigFile(fileUrl) {
            fileUrl = String(fileUrl)
            fileUrl = fileIO.removePathoverhead(fileUrl)

            let canvasSave = canvas.save()
            let viewAreaSave = viewArea.save()
            let saveData = {
                "canvas": canvasSave,
                "viewArea": viewAreaSave
            }

            fileIO.saveTextFile(JSON.stringify(saveData), fileUrl)

            configFileUrl = fileUrl
        }

        function openConfigFile(fileUrl) {
            fileUrl = String(fileUrl)
            fileUrl = fileIO.removePathoverhead(fileUrl)

            var saveData = fileIO.openTextFile(fileUrl)
            var loadData = JSON.parse(saveData)

            canvas.load(loadData["canvas"])
            viewArea.load(loadData["viewArea"])

            canvas.calculateMinimumSize()

            configFileUrl = fileUrl
        }
    }
}
