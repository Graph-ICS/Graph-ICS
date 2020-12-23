import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.12

import Theme 1.0


Item {
    id: graphics_FileButton
    property var nameFilters: []
    property bool selectExisting: true
    height: 24
    width: height
    signal accepted(string fileUrl)

    property color buttonColor: "transparent"

    GButton {
        id: fileButton
        z: 1
        anchors.fill: parent

        width: parent.height + 2
        height: parent.height
        transparent: true
        onEntered: {
            color.color = Theme.node.color.border.hover
        }
        onExited: {
            color.color = graphics_FileButton.buttonColor
        }

        Image {
            id: icon
            source: "qrc:/img/folder.svg"
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
        }

        ColorOverlay {
            id: color
            color: graphics_FileButton.buttonColor
            anchors.fill: icon
            source: icon
        }

        onClicked: {
            pathDialog.open();
        }
    }

    FileDialog {
        id: pathDialog
        nameFilters: graphics_FileButton.nameFilters
        selectedNameFilter: graphics_FileButton.nameFilters[0]
        selectExisting: graphics_FileButton.selectExisting
        onAccepted: {
            graphics_FileButton.accepted(fileUrl)
        }
    }

}

