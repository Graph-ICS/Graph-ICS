import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15 as QQC2Window
import QtGraphicalEffects 1.0
import Qt.labs.settings 1.1

import "../components/"
import "../node/"
import Theme 1.0

QQC2Window.Window {
    id: connectionsDialog

    height: minimumHeight
    width: minimumWidth

    minimumWidth: 420
    minimumHeight: contentColumn.height

    flags: Qt.Dialog

    modality: Qt.ApplicationModal

    title: qsTr("Graph-ICS - Server Connection")

    property bool isConnected: false
    property bool isConnecting: false

    property string ipText: ipTextField.text
    property int portValue: parseInt(portTextField.text)

    property var savedConnections: []

    property int _spacing: Theme.largeSpacing
    property int _marginWidth: 11

    Component.onCompleted: {
        savedConnections = settings.connections
        loadComboBox.model.append({
                                      "name": "",
                                      "buttonVisible": false
                                  })
        loadComboBox.updateModel()
        if (savedConnections.length > 0) {
            loadComboBox.currentIndex = 1
        } else {
            loadComboBox.currentIndex = 0
        }
    }

    Component.onDestruction: {
        settings.connections = savedConnections
    }

    Settings {
        id: settings
        property var connections: []
    }

    Item {
        id: content
        anchors.fill: parent

        GBackground {
            anchors.fill: parent
        }

        MouseArea {
            id: ma
            anchors.fill: parent
            onPressed: {
                forceActiveFocus()
            }
        }
        Column {
            id: contentColumn
            width: parent.width - padding * 2
            padding: _marginWidth * 2
            spacing: 18
            RowLayout {
                id: ipPortRow

                spacing: _spacing
                height: Theme.baseHeight
                width: parent.width

                GText {

                    Layout.fillHeight: true
                    Layout.preferredWidth: implicitWidth

                    text: "IP"
                    font: Theme.font.body2

                    verticalAlignment: Text.AlignVCenter
                }
                GTextField {
                    id: ipTextField

                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.preferredWidth: 180

                    backgroundColor: Theme.background

                    enabled: !namePopup.visible && !isConnected && !isConnecting

                    font: Theme.font.body2

                    maximumLength: 42

                    onTextEdited: {
                        messageText.text = ""
                    }

                    onAccepted: {
                        ma.forceActiveFocus()
                    }
                }
                GText {

                    Layout.fillHeight: true
                    Layout.preferredWidth: implicitWidth

                    text: "Port"
                    font: Theme.font.body2

                    verticalAlignment: Text.AlignVCenter
                }
                GTextField {
                    id: portTextField

                    Layout.fillHeight: true
                    Layout.preferredWidth: 60

                    enabled: !namePopup.visible && !isConnected && !isConnecting
                    font: Theme.font.body2
                    backgroundColor: Theme.background

                    maximumLength: 5

                    validator: RegExpValidator {
                        regExp: /^([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$/
                    }
                    onTextEdited: {
                        messageText.text = ""
                    }

                    onAccepted: {
                        ma.forceActiveFocus()
                    }
                }
                GButton {

                    Layout.fillHeight: true
                    Layout.preferredWidth: 80

                    enabled: ipTextField.acceptableInput
                             && portTextField.acceptableInput
                             && !namePopup.visible && !isConnected
                             && !isConnecting
                    text: qsTr("Save")

                    onClicked: {
                        if (loadComboBox.currentIndex == 0) {
                            namePopup.visible = true
                        } else {
                            savedConnections.forEach(function (connection) {
                                if (connection.Name === loadComboBox.currentText) {
                                    connection.IP = ipText
                                    connection.Port = portValue
                                }
                            })
                        }
                    }
                }
            }

            Rectangle {
                height: 1
                width: contentColumn.width
                color: Theme.primary
            }

            Column {
                width: contentColumn.width
                spacing: _spacing
                GText {
                    text: qsTr("Load existing Connection")
                    font: Theme.font.body2
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width
                }

                GComboBox {
                    id: loadComboBox

                    width: parent.width
                    height: Theme.baseHeight

                    buttonVisible: true
                    buttonIcon: Theme.icon.clear
                    buttonToolTipText: qsTr("Delete this Connection")

                    backgroundColor: Theme.background

                    enabled: !isConnected && !isConnecting && !namePopup.visible
                    onDownChanged: {
                        if (down) {
                            let h = popup.contentItem.implicitHeight
                            let y = loadComboBox.y + loadComboBox.height
                            let pos = mapToItem(contentColumn, 0, y)
                            y = pos.y
                            if (y + h > connectionsDialog.height) {
                                connectionsDialog.height = (y + h) - connectionsDialog.height
                                        + connectionsDialog.height
                            }
                        }
                    }

                    onCurrentIndexChanged: {
                        if (currentIndex == 0) {
                            ipTextField.text = ""
                            portTextField.text = ""
                        } else {
                            let connection = savedConnections[currentIndex - 1]
                            ipTextField.text = connection.IP
                            portTextField.text = connection.Port
                        }
                        messageText.text = ""
                    }

                    onButtonClicked: {
                        model.remove(index)
                        currentIndex = 0
                        updatePopupHeight()
                        savedConnections.splice(index - 1, 1)
                    }

                    function updateModel() {
                        if (savedConnections.length > model.count - 1) {
                            for (var i = model.count - 1; i < savedConnections.length; i++) {
                                model.append({
                                                 "name": savedConnections[i].Name,
                                                 "buttonVisible": true
                                             })
                            }
                        }
                    }
                }
            }

            Rectangle {
                height: 1
                width: contentColumn.width
                color: Theme.primary
            }

            Row {
                spacing: _spacing

                FishSpinner {
                    id: loadingIndicator
                    radius: 10
                    color: Theme.primary
                    visible: isConnecting
                }

                GText {
                    id: messageText
                    horizontalAlignment: Text.AlignHCenter
                    text: ""
                    anchors.verticalCenter: connectButton.verticalCenter
                    width: {
                        if (isConnecting) {
                            return contentColumn.width - statusIndicator.width
                                    - connectButton.width - 3 * _spacing - loadingIndicator.width
                        } else {
                            return contentColumn.width - statusIndicator.width
                                    - connectButton.width - 2 * _spacing
                        }
                    }
                }
                Rectangle {
                    id: statusIndicator
                    anchors.verticalCenter: connectButton.verticalCenter
                    color: "transparent"
                    border.width: 2
                    height: 18
                    width: height
                    radius: height / 2
                    border.color: isConnected ? "green" : "red"
                    Rectangle {
                        anchors.centerIn: parent
                        height: 10
                        width: height
                        radius: height / 2
                        color: isConnected ? "green" : "red"
                    }
                }
                GButton {
                    id: connectButton
                    enabled: ipTextField.acceptableInput
                             && portTextField.acceptableInput
                             && !namePopup.visible && !isConnecting
                    text: isConnected ? qsTr("Disconnect") : qsTr("Connect")
                    height: Theme.baseHeight
                    width: 124

                    onClicked: {
                        if (isConnected) {
                            commThread.disconnect()
                            messageText.text = ""
                            isConnected = false
                        } else {
                            isConnecting = commThread.startConnecting(ipText,
                                                                      portValue)
                            if (isConnecting) {
                                messageText.text = qsTr("Connecting...")
                            } else {
                                messageText.text = qsTr("Unknown host!")
                            }
                        }
                    }
                }
            }
        }
    }

    ShaderEffectSource {
        id: effectSource
        sourceItem: content
        width: parent.width
        height: parent.height
        sourceRect: Qt.rect(x, y, width, height)
    }

    FastBlur {
        anchors.fill: effectSource
        source: effectSource
        radius: 20
        visible: namePopup.visible
    }

    Popup {
        id: namePopup
        height: column.height
        width: parent.width - _marginWidth * 6
        visible: false
        onVisibleChanged: {
            forceActiveFocus()
            nameTextField.text = ""
            msgText.state = 'info'
        }
        anchors.centerIn: parent
        contentItem: Item {
            anchors.fill: parent
            Column {
                id: column
                width: parent.width - padding * 2
                padding: _marginWidth * 2
                spacing: 10
                GText {
                    id: msgText
                    horizontalAlignment: Text.AlignHCenter
                    states: [
                        State {
                            name: "info"
                            PropertyChanges {
                                target: msgText
                                text: qsTr("Enter a Name to identify the Connection")
                            }
                        },
                        State {
                            name: "nameExists"
                            PropertyChanges {
                                target: msgText
                                text: qsTr("This Name already exists!")
                            }
                        }
                    ]
                    state: 'info'
                }

                GTextField {
                    id: nameTextField

                    font: Theme.font.body2

                    height: Theme.baseHeight
                    width: parent.width
                    backgroundColor: Theme.background
                    maximumLength: 24
                    validator: RegExpValidator {
                        regExp: /^[a-zA-Z0-9_]+( [a-zA-Z0-9_]+)*$/
                    }

                    onTextEdited: {
                        msgText.state = 'info'
                    }
                }

                Item {
                    height: Theme.baseHeight
                    width: parent.width
                    GButton {
                        text: qsTr("Cancel")
                        height: parent.height
                        width: 80
                        anchors.left: parent.left
                        onClicked: namePopup.visible = false
                    }
                    GButton {
                        text: qsTr("Save")
                        enabled: nameTextField.text !== ""
                        height: parent.height
                        width: 80
                        anchors.right: parent.right
                        onClicked: {
                            let valid = true
                            savedConnections.forEach(function (connection) {
                                if (connection.Name === nameTextField.text) {
                                    valid = false
                                }
                            })
                            if (valid) {
                                savedConnections.push({
                                                          "IP": ipText,
                                                          "Port": portValue,
                                                          "Name": nameTextField.text
                                                      })
                                loadComboBox.updateModel()
                                loadComboBox.currentIndex = savedConnections.length

                                namePopup.visible = false
                            } else {
                                msgText.state = 'nameExists'
                            }
                        }
                    }
                }
            }
        }

        background: GBackground {
            MouseArea {
                anchors.fill: parent
                onClicked: forceActiveFocus()
            }
        }
    }

    Connections {
        target: commThread
        function onConnectHandled(isConnected) {
            connectionsDialog.isConnected = isConnected
            if (isConnected) {
                messageText.text = qsTr("Connection established!")
            } else {
                messageText.text = qsTr("Connection failed!")
            }
            isConnecting = false
        }
    }
}
