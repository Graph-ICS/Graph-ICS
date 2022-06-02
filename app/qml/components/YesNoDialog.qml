import QtQuick 2.15
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

import QtQuick.Window 2.15

import Theme 1.0

Window {
    id: dialog

    // clients can react to the signals, specify the callbacks, or use both
    // in the last scenario callbacks are called before the signal is emitted
    signal yes
    signal no
    property var yesCallback
    property var noCallback

    property alias content: content
    property alias text: content.text
    property alias yesButton: yesButton
    property alias noButton: noButton

    property int defaultWidth: 260

    property bool isDecisionMade: false

    minimumWidth: buttons.Layout.minimumWidth + 2 * background.getMarginWidth()
    minimumHeight: calculateMinimumHeight()

    //    maximumHeight: minimumHeight
    onVisibleChanged: {
        width = defaultWidth
        height = minimumHeight
        if (visible) {
            isDecisionMade = false
        }
    }

    title: qsTr("Yes No - Dialog")

    flags: Qt.Dialog
    modality: Qt.ApplicationModal
    transientParent: root

    function calculateMinimumHeight() {
        return contentColumn.getMinimumHeight(
                    ) + 2 * background.getMarginWidth()
    }

    GBackground {
        id: background
        anchors.fill: parent
    }

    ColumnLayout {
        id: contentColumn
        anchors.fill: parent

        anchors.margins: background.getMarginWidth()

        spacing: Theme.largeSpacing

        function getMinimumHeight() {
            let val = 0
            for (var i = 0; i < children.length; i++) {
                val += children[i].Layout.minimumHeight
            }
            return val + (children.length - 1) * spacing
        }

        Text {
            id: content

            property int defaultHeight: 60

            Layout.fillWidth: true
            Layout.minimumHeight: defaultHeight

            Layout.preferredHeight: defaultHeight
            Layout.fillHeight: true

            text: "Yes or No?"

            font: Theme.font.body1
            color: Theme.onbackground
            textFormat: Text.RichText
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
            maximumLineCount: 3

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Item {
            id: buttons

            Layout.minimumHeight: height
            Layout.minimumWidth: width
            Layout.alignment: Qt.AlignHCenter

            property int buttonWidth: 72
            property int buttonSpace: 12
            width: buttonWidth * 2 + buttonSpace
            height: Theme.baseHeight

            GButton {
                id: yesButton

                anchors.left: parent.left

                hoverEnabled: true
                text: qsTr("Yes")

                width: parent.buttonWidth
                height: parent.height

                onClicked: {
                    isDecisionMade = true
                    if (yesCallback) {
                        yesCallback()
                    }
                    yes()
                }
            }
            GButton {
                id: noButton

                anchors.right: parent.right

                hoverEnabled: true
                text: qsTr("No")

                width: parent.buttonWidth
                height: parent.height

                onClicked: {
                    isDecisionMade = true
                    if (noCallback) {
                        noCallback()
                    }
                    no()
                }
            }
        }
    }

    function open(displayText, yesCallback, noCallback) {
        if (displayText !== "") {
            dialog.content.text = displayText
        }
        dialog.yesCallback = yesCallback
        dialog.noCallback = noCallback
        dialog.showNormal()
    }
}
