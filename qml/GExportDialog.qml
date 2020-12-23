import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

import "components/"
import Theme 1.0

Window {
    id: graphics_ExportDialog

    height: 198
    width:  548
    minimumHeight: 198
    minimumWidth: 548
    maximumHeight: 342
    maximumWidth: 748
    flags: Qt.Window | Qt.WindowSystemMenuHint
           | Qt.WindowTitleHint | Qt.WindowCloseButtonHint | Qt.WindowStaysOnTopHint

    title: "Graph-ICS - Video Export"

    property bool isExporting: false
    property var nodeToExport: null

    onVisibilityChanged: {
        if(visible)
            requestActivate()
    }

    onClosing: {
        pathTextField.text = ""
        exportLabel.text = ""
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.contentDelegate.color.background.hover

        Rectangle {
            anchors.fill: parent
            anchors.margins: 24

            color: Theme.mainColor
            Label {
                id: pathLabel
                text: "Export your selected Video Stream"
                horizontalAlignment: Text.AlignHCenter
                color: Theme.contentDelegate.color.text.normal
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    topMargin: 12
                }
                height: font.pointSize + 16
                font.pointSize: Theme.font.pointSize
                font.family: Theme.font.family
            }
            RowLayout {
                id: row
                anchors.top: pathLabel.bottom
                anchors.topMargin: 12
                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.right: parent.right
                anchors.rightMargin: 12
                spacing: 7

                GTextField {
                    id: pathTextField
                    enabled: false

                    backgroundColor: Theme.contentDelegate.color.background.press
                    color: Theme.contentDelegate.color.text.press

                    borderColor: Theme.node.color.border.hover
                    Layout.fillWidth: true
                    height: font.pointSize + 16
                    font.pointSize: Theme.font.pointSize
                    font.family: Theme.font.family
                    placeholderText: "select an output Path"
                }

                GFileButton {
                    id: fileButton
                    buttonColor: Theme.contentDelegate.color.background.press
                    selectExisting: false
                    nameFilters: [ "Video files (*.mp4)", "All files (*)" ]
                    onAccepted: {
                        pathTextField.text = fileIO.removePathoverhead(fileUrl)
                    }
                }

            }

            RowLayout{
                id: buttonRow
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                anchors.bottomMargin: 12
                spacing: 12

                FishSpinner {
                    id: loadingAnimation
                    radius: 10
                    color: Theme.accentColor
                    visible: graphics_ExportDialog.isExporting
                }

                Label {
                    id: exportLabel
                    Layout.fillWidth: true
                    width: implicitWidth

                    horizontalAlignment: Text.AlignHCenter
                    color: Theme.contentDelegate.color.text.normal
                    height: font.pointSize + 16
                    font.pointSize: Theme.font.pointSize
                    font.family: Theme.font.family
                    wrapMode: Text.NoWrap
                }

                GButton {
                    id: cancelButton
                    Layout.fillWidth: false
                    text: "Cancel"
                    height: 24
                    width: 72
                    onClicked: {
                        pathTextField.text = ""
                        exportLabel.text = ""
                        graphics_ExportDialog.close()
                    }
                }

                GButton {
                    id: exportButton
                    Layout.fillWidth: false
                    text: "Export"
                    height: 24
                    width: 72
                    onClicked: {
                        if(pathTextField.text == ""){
                            exportLabel.text = "You need to select an output Path!"
                        } else {
                            exportLabel.text = "exporting..."
                            loadingAnimation.visible = true
                            fileButton.enabled = false
                            exportButton.enabled = false
                            cancelButton.enabled = false
                            graphics_ExportDialog.flags = Qt.Window | Qt.WindowSystemMenuHint
                                    | Qt.WindowTitleHint | Qt.WindowStaysOnTopHint
                            exportButton.state = 'normal'

                            fileIO.writeVideoFile(pathTextField.text, nodeToExport.model)
                        }
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                z: -1
                onClicked: {
                    forceActiveFocus()
                }
            }
        }
    }

    Connections {
        target: fileIO

        function onVideoExported(status){
            if(status)
                exportLabel.text = "Video sucessfully exported!"
            else
                exportLabel.text = "Video couldn't be exported, check your configuration"

            loadingAnimation.visible = false

            fileButton.enabled = true
            exportButton.enabled = true
            cancelButton.enabled = true
            graphics_ExportDialog.flags = Qt.Window | Qt.WindowSystemMenuHint
                    | Qt.WindowTitleHint | Qt.WindowCloseButtonHint | Qt.WindowStaysOnTopHint
        }
    }
}
