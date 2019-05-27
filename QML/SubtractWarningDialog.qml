import QtQuick 2.10
import QtQuick.Controls 2.4
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

import QtQuick.Window 2.11


Window {
    width: 408
    height: 175
    //id: popup;
//    minimumWidth: 350;
//    maximumWidth: 350;
//    minimumHeight: 200
//    maximumHeight: 200;
    color: "grey"
    modality: Qt.WindowModal
   // titel: "skd"

    Label {
        id : label
        x: 146
        y: 20
        width: 116
        height: 29
        color: "white"
        text: "Warning"
        wrapMode: Text.WordWrap
        font.bold: true
        font.weight: Font.Bold
        font.pointSize: 15
    }
    Text {
        x: 55
        y: 62
        width: 290
        height: 72
        color: "white"
        font.pointSize: 10
        text: qsTr("Please make sure that the first image is smaller than the second image")
        wrapMode: Text.WordWrap
    }
}
