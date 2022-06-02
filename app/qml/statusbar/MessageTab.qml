import QtQuick 2.15
import QtQuick.Controls 2.15

import Global 1.0
import Theme 1.0

import "../components"

Item {
    id: graphics_TextArea

    property alias textArea: textArea

    GFlickable {
        id: flickable
        anchors.fill: parent

        contentWidth: width
        contentHeight: textArea.height

        onContentHeightChanged: {
            if (contentHeight > height) {
                contentY = contentHeight - height
            }
        }

        ScrollBar.vertical: GScrollBar {
            id: vScrollBar
            parent: flickable.parent
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
        }

        ScrollBar.horizontal: GScrollBar {
            id: hScrollBar
            parent: flickable.parent
            policy: ScrollBar.AlwaysOff
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
        }

        TextArea {
            id: textArea
            leftPadding: Theme.smallSpacing + vScrollBar.width
            width: parent.width

            readOnly: true

            font: Theme.font.body2
            color: Theme.onsurface
            selectionColor: Theme.primary
            selectedTextColor: Theme.onprimary

            textFormat: TextEdit.RichText
            selectByMouse: true
            persistentSelection: true
            placeholderText: qsTr("no Messages...")

            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }
    }

    MouseArea {
        anchors.fill: flickable

        cursorShape: Qt.IBeamCursor
        acceptedButtons: Qt.RightButton

        onWheel: flickable.scrollContent(wheel)
        onClicked: {
            menu.popup()
        }
    }

    GMenu {
        id: menu

        delegate: GMenuItem {}

        Action {
            text: qsTr("Copy")
            enabled: textArea.selectedText != ""
            onTriggered: {
                textArea.copy()
            }
        }

        Action {
            text: qsTr("Paste")
            enabled: textArea.canPaste
            onTriggered: {
                textArea.paste()
            }
        }

        Action {
            text: qsTr("Select All")
            enabled: textArea.text != ""
            onTriggered: {
                textArea.selectAll()
            }
        }

        Action {
            text: qsTr("Clear")
            enabled: textArea.text != ""
            onTriggered: {
                textArea.clear()
            }
        }
    }

    property color oldMessageColor: Theme.darkMode ? Qt.darker(
                                                         Theme.onsurface) : Qt.lighter(
                                                         Theme.onsurface, 5)
    property color newMessageColor: Theme.onsurface

    property string oldColor: oldMessageColor
    property string newColor: newMessageColor

    property string messageTemplate: "<p style='color:%1;' >%2</p>"

    function addMessage(msg, color) {
        if (msg === "") {
            console.debug(
                        "messageTab.addMessage: Trying to print empty message!")
            return
        }
        textArea.append(messageTemplate.arg(color).arg(msg))
        textArea.cursorPosition = textArea.length - 1
    }

    function printWarning(msg) {
        newColor = newMessageColor
        oldColor = oldMessageColor
        let text = String(textArea.text)
        textArea.text = changeTextColor(text, newColor, oldColor)
        addMessage(msg, newColor)
    }

    function clear() {
        textArea.clear()
    }

    function changeTextColor(text, oldColor, newColor) {
        return text.split(oldColor).join(newColor)
    }

    Connections {
        target: Global.themeSettings
        function onDarkModeEnabledChanged() {
            let text = String(textArea.text)
            text = changeTextColor(text, oldColor, oldMessageColor)
            text = changeTextColor(text, newColor, newMessageColor)
            textArea.text = text

            newColor = newMessageColor
            oldColor = oldMessageColor
        }
    }
}
