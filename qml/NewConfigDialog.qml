import QtQuick 2.10
import QtQuick.Controls 2.4
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

import QtQuick.Window 2.11

import Theme 1.0

import "components/"

Window {
    id: popup;

    title: "Graph-ICS - Configuration Warning"

    width: label.width + 22
    height: 74

    minimumHeight: 74
    maximumHeight: 74

    minimumWidth: label.width + 22
    maximumWidth: label.width + 22

    color: Theme.mainColor

    onActiveChanged: {
        buttonYes.content.highlight.running = true
    }

    Label {
        id : label
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 12

        color: Theme.contentDelegate.color.text.normal
        text: "Do you want to save your Configuration?"
        font.pointSize: Theme.font.pointSize
        font.family: Theme.font.family
    }

    GButton {
        id: buttonYes

        anchors.right: buttonNo.left
        anchors.rightMargin: 12
        anchors.top: buttonNo.top
        anchors.bottom: buttonNo.bottom

        width: 72
        height: 28
        text: "Yes"

        onClicked: {
            menuBar.saveConfig()
        }
    }
    GButton {
        id: buttonNo
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: label.bottom
        anchors.margins: 12
        width: 72
        height: 28
        text: "No"

        onClicked: {
            menuBar.resetConfig();
            popup.close();
            content.state = 'normal'
        }
    }
    GButton {
        id: buttonCancel
        anchors.left: buttonNo.right
        anchors.leftMargin: 12
        anchors.top: buttonNo.top
        anchors.bottom: buttonNo.bottom
        width: 72
        height: 28
        text: "Cancel"

        onClicked: {
            popup.close();
            content.state = 'normal'
        }
    }

}
