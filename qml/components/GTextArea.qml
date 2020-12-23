import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import Theme 1.0

Item {
    id: graphics_TextArea

    property bool copied: false
    QQC2.ScrollView {
        anchors.fill: parent
        clip: true

        QQC2.TextArea {
            id: textArea
            font.family: Theme.font.family
            font.pointSize: Theme.font.pointSize
            color: Theme.contentDelegate.color.text.normal
            selectByMouse: true
            selectionColor: Theme.accentColor
            selectedTextColor: Theme.textField.color.text.select
            persistentSelection: true
            placeholderText: "no Messages..."
            wrapMode: Text.WordWrap
        }

        MouseArea {
            anchors.fill: textArea
            acceptedButtons: Qt.RightButton

            onClicked: {
                menu.popup()
            }
        }
    }

    GMenu {
        id: menu

        QQC2.Action {
            text: "Copy"
            enabled: textArea.selectedText != ""
            onTriggered: {
                textArea.copy()
                copied = true
            }
        }

        QQC2.Action {
            text: "Paste"
            enabled: copied
            onTriggered: {
                textArea.paste()

            }
        }

        QQC2.Action {
            text: "Select All"
            enabled: textArea.text != ""
            onTriggered: {
                textArea.selectAll()
            }
        }

        QQC2.Action {
            text: "Clear"
            enabled: textArea.text != ""
            onTriggered: {
                textArea.clear()
            }
        }
    }

    function append(text){
        textArea.text += text + "\n"
        textArea.cursorPosition = textArea.length - 1
    }

}


