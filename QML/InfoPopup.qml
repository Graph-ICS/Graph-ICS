import QtQuick 2.10
import QtQuick.Controls 2.4
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

import QtQuick.Window 2.11


Window {
    id: popup;
    minimumWidth: 350;
    maximumWidth: 350;
    minimumHeight: 270
    maximumHeight: 270;
    color: "#605f5f"
    modality: Qt.WindowModal
    //flags: Qt.WindowCloseButtonHint
    
    Label {
        id : label
        x: 10
        y: 10
        width: 319
        height: 40
        color: "#ffffff"
        text: "Graph Based Medical Image Computing (GraphMIC)"
        wrapMode: Text.WordWrap
        font.bold: true
        font.weight: Font.Bold
        font.pointSize: 13
    }
    Text {
        x: logoCES.x + logoCES.width + 10
        y: label.y + label.height + 10
        width: 218
        height: 184
        color: "#ffffff"
        font.pointSize: 10
        text: qsTr("Based on Qt 5.11.0 \n(MSVC 2017, 64Bit)\n\n" +
                   "Build on Sept 12 2018 14:46:12 " +
                   "Copyright ... \n\n" +
                   "The program is provided AS IS with" +
                   " NO WARRANTY OF ANY KIND, INCLUDING THE WARRANTY OF DESIGN,"+
                   " MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE")
        wrapMode: Text.WordWrap
    }
    
    Image {
        id: logoCES
        x: 10
        y: label.y + label.height + 10
        width: 100
        height: 100
        source: "../doc/LogoCES.png"
    }
    Image {
        id: logoRemic
        x: 10
        y: logoCES.y + logoCES.height + 5
        width: 100
        height: 100
        source: "../doc/RemicLogo.PNG"
    }
}
