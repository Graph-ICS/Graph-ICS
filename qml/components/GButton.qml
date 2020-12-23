import QtQuick 2.0
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Controls.Styles 1.4
import Theme 1.0


// Custom Button fuer Graph-ICS
// QML-Button implementierung angepasst

MouseArea {
    id: graphics_Button
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    hoverEnabled: true
    property bool transparent: false
    property string text: ""

    property alias content: content
    content.state: transparent ? 'transparent' : 'normal'

    GContentDelegate {
        id: content
        anchors.fill: parent
        textLabel.text: graphics_Button.text
    }

    onEntered: {
        if(!transparent)
            content.state='hover'
    }

    onExited: {
        if(!transparent)
            content.state='normal'
    }

    onPositionChanged: {
    }

    onPressed: {
        if(!transparent)
            content.state='press'
    }

    onReleased: {
        if(!transparent){
            if (containsMouse)
              content.state='hover'
            else
              content.state='normal'
        }
    }
}


