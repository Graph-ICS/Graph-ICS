import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.12

import Theme 1.0

Item {
    id: graphics_FileButton
    signal accepted(string fileUrl)

    property alias fileDialog: pathDialog
    property bool selectExisting: true
    property bool selectFolder: false

    height: 24
    width: height

    property alias iconButton: fileButton

    GIconButton {
        id: fileButton
        z: 1
        anchors.fill: parent

        width: parent.height + 2
        height: parent.height
        icon.source: Theme.icon.file

        icon.color: "black"
        transparent: true

        onClicked: {
            pathDialog.open()
        }
    }

    FileDialog {
        id: pathDialog

        folder: shortcuts.home
        selectedNameFilter: {
            if (nameFilters.length > 0) {
                return nameFilters[0]
            }
            return ""
        }
        selectExisting: graphics_FileButton.selectExisting
        selectFolder: graphics_FileButton.selectFolder
        onAccepted: {
            graphics_FileButton.accepted(fileUrl)
        }
    }
}
