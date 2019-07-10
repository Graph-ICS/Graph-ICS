import QtQuick 2.10
import QtQuick.Controls 2.4
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

import QtQuick.Window 2.11


Window {
    width: 408
    height: 175
    color: "grey"
    modality: Qt.WindowModal

    Label {
        id : label
        x: 146
        y: 20
        width: 116
        height: 29
        color: "white"
        text: "Progress"
        wrapMode: Text.WordWrap
        font.bold: true
        font.weight: Font.Bold
        font.pointSize: 15
    }
   BusyIndicator { x: 174;y: 74}

}
