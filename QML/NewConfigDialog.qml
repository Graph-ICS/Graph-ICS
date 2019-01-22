import QtQuick 2.10
import QtQuick.Controls 2.4
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

import QtQuick.Window 2.11

Window {
    id: popup;
    width: 324
    height: 100
    color: "white"
    modality: Qt.WindowModal

    Label {
        id : label
        x: 10
        y: 10
        width: 375
        height: 26
        color: "black"
        text: "Do you want to save your Configuration?"
        wrapMode: Text.WordWrap
        font.pointSize: 11
    }
    Button {
        id: buttonYes
        x: 24
        y: 58
        width: 80
        text: "Yes"
        onClicked: {
            saveFileDialog.open();
            isConfigReadyToClear = true;
            popup.close();
        }
    }
    Button {
        id: buttonNo
        x: 122
        y: 58
        width: 80
        text: "No"
        onClicked: {
            resetConfig();
            popup.close();
        }
    }
    Button {
        id: buttonCancel
        x: 219
        y: 58
        width: 80
        text: "Cancel"
        onClicked: {
            popup.close();
        }
    }
}
