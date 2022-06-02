import QtQuick 2.15
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

import QtQuick.Window 2.15

import Theme 1.0
import Global 1.0

import "../components"

Window {
    id: dialog

    property int defaultWidth: 260

    width: defaultWidth
    height: minimumHeight

    minimumWidth: defaultWidth
    minimumHeight: calculateMinimumHeight()

    maximumWidth: defaultWidth
    maximumHeight: minimumHeight

    title: qsTr("Graph-ICS - Find Help")

    flags: Qt.Dialog
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

            property int defaultHeight: Theme.baseHeight

            Layout.fillWidth: true
            Layout.minimumHeight: defaultHeight + padding * 2

            Layout.preferredHeight: defaultHeight
            Layout.fillHeight: true

            padding: Theme.largeSpacing
            text: qsTr(
                      "Make sure to read our <br> <style>a:link { color: "
                      + Theme.secondary + ";} </style> <a href='"
                      + Global.onlineDocsLink + "'>Online Documentation</a> :)")

            font: Theme.font.body1
            color: Theme.onbackground
            textFormat: Text.RichText
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
            maximumLineCount: 3

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            onLinkActivated: {
                menubar.openHelpBrowserAction.trigger()
            }
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.NoButton
                cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
            }
        }

        GSwitchDelegate {

            Layout.alignment: Qt.AlignRight
            Layout.minimumHeight: Theme.baseHeight

            text: qsTr("Don't show again")
            height: Theme.baseHeight
            checked: false
            onCheckedChanged: {
                Global.behaviorSettings.showFindHelp = !checked
            }
        }
    }
}
