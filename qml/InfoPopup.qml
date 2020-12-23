import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.2

import QtQuick.Window 2.11

import Theme 1.0

Window {
    id: popup;
    title: "Graph-ICS - Info"
    minimumWidth: 350
    maximumWidth: 350
    minimumHeight: label.height + logoCES.height + logoRemic.height + 40
    maximumHeight: label.height + logoCES.height + logoRemic.height + 40
    color: Theme.mainColor
    
    Label {
        id : label
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 10

        color: Theme.contentDelegate.color.text.press
        text: "Graphical Image Computing System (Graph-ICS)"
        wrapMode: Text.WordWrap
        font.bold: true
        font.family: Theme.font.family
        font.pointSize: Theme.font.pointSize
    }
    Text {
        id: text1
        anchors.top: label.bottom
        anchors.left: logoCES.right
        anchors.margins: 10
        width: 218
//        height: 184
        color: Theme.contentDelegate.color.text.hover
        font.family: Theme.font.family
        font.pointSize: Theme.font.pointSize
        text: "Based on Qt 5.15.1 \n(MSVC 2015, 64Bit)\n\n" +
                   "Build on 23.12.2020 " +
                   "Copyright ... \n\n" +
                   "The program is provided AS IS with" +
                   " NO WARRANTY OF ANY KIND, INCLUDING THE WARRANTY OF DESIGN,"+
                   " MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE\n"

        wrapMode: Text.WordWrap

    }
    Text {
        anchors.top: text1.bottom
        anchors.left: logoCES.right
        anchors.margins: 10
        width: 218
        color: Theme.contentDelegate.color.text.hover
        font.family: Theme.font.family
        font.pointSize: Theme.font.pointSize
        text: "Folder-Icon used from <a href='https://www.iconfinder.com/sudheepb'>sudheepb</a>\n" +
        "Video-Control-Icons: <a href='https://www.iconfinder.com/iconsets/music-player-controls'>music-player-controls-pack</a>"
        wrapMode: Text.WordWrap
        onLinkActivated: {
            Qt.openUrlExternally(link)
        }
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton
            cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
        }
    }
    
    Image {
        id: logoCES
        anchors.top: label.bottom
        anchors.left: parent.left
        anchors.margins: 10
        width: 100
        height: 100
        source: "qrc:/img/LogoCES.png"
    }
    Image {
        id: logoRemic
        anchors.left: parent.left
        anchors.top: logoCES.bottom
        anchors.margins: 10
        width: 100
        height: 100
        source: "qrc:/img/RemicLogo.png"
    }
}
