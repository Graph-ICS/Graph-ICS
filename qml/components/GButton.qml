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
    property alias toolTip: toolTip
    property alias content: content
    content.state: transparent ? 'transparent' : 'normal'
    cursorShape: enabled ? containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor : Qt.ArrowCursor

    QQC2.ToolTip {
        id: toolTip
        text: ""
        delay: 1000
        visible: false
        contentItem: Text {
            text: toolTip.text
            font.family: Theme.font.family
            font.pointSize: Theme.font.pointSize
            color: Theme.contentDelegate.color.text.press
        }
        background: Rectangle {
            color: Theme.contentDelegate.color.background.press
        }
    }

    GContentDelegate {
        id: content
        anchors.fill: parent
        textLabel.text: graphics_Button.text
    }

    onEntered: {
        if(!transparent)
            content.state='hover'

        if(toolTip.text !== ""){
            toolTip.visible = true
        }
    }

    onExited: {
        if(!transparent)
            content.state='normal'
        toolTip.visible = false
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
    onEnabledChanged: {
        if(enabled){
            content.state = 'normal'
        } else {
            content.state = 'disabled'
        }
        toolTip.hide()
    }

}


