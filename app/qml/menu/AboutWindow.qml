import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.15

import QtQuick.Layouts 1.15

import Theme 1.0

import "../components"

Window {
    id: popup

    property string qtVersion: appInfo ? appInfo.getQtVersion() : ""
    property string appVersion: appInfo ? appInfo.getAppVersion() : ""
    property string appDescription: appInfo ? appInfo.getAppDescription() : ""

    property int imageSize: 100

    title: qsTr("About Graph-ICS")

    height: minimumHeight
    width: minimumWidth

    minimumHeight: 400
    minimumWidth: 460

    flags: Qt.Dialog
    transientParent: root

    GBackground {
        id: background
        anchors.fill: parent
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: background.getMarginWidth()

        spacing: 0

        RowLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true

            spacing: Theme.largeSpacing

            ColumnLayout {
                id: leftColumn

                Layout.fillHeight: true
                Layout.fillWidth: true

                spacing: Theme.largeSpacing

                Image {
                    id: logoCES

                    Layout.preferredHeight: imageSize
                    Layout.preferredWidth: imageSize

                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/LogoCES.png"

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Qt.openUrlExternally(
                                       "https://conti-engineering.com/")
                        cursorShape: Qt.PointingHandCursor
                    }
                }
                Image {
                    id: logoRemic

                    Layout.preferredHeight: imageSize
                    Layout.preferredWidth: imageSize

                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/RemicLogo.png"

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Qt.openUrlExternally("https://re-mic.de/")
                        cursorShape: Qt.PointingHandCursor
                    }
                }
                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
            }
            ColumnLayout {
                id: rightColumn

                Layout.fillHeight: true
                Layout.fillWidth: true

                spacing: 0

                Text {
                    id: title

                    Layout.preferredHeight: implicitHeight
                    Layout.fillWidth: true

                    text: "Graph-ICS"
                    verticalAlignment: Text.AlignTop
                    horizontalAlignment: Text.AlignLeft

                    color: Theme.onbackground
                    font: Theme.font.h4

                    wrapMode: Text.WordWrap
                }
                Text {
                    id: description

                    Layout.fillWidth: true
                    Layout.preferredHeight: implicitHeight

                    textFormat: Text.RichText
                    text: "<br>" + qsTr(appDescription) + "<br>"

                    verticalAlignment: Text.AlignTop
                    horizontalAlignment: Text.AlignLeft

                    color: Theme.onbackground
                    font: Theme.font.body1

                    wrapMode: Text.WordWrap
                }
                Text {
                    id: ghLink

                    Layout.fillWidth: true
                    Layout.preferredHeight: implicitHeight

                    textFormat: Text.RichText
                    text: qsTr("Find us on GitHub") + ":<br>"
                          + "<style>a:link { color: " + Theme.secondary + ";} </style>"
                          + "<a href='https://github.com/Graph-ICS/Graph-ICS'>https://github.com/Graph-ICS/Graph-ICS</a>"
                    verticalAlignment: Text.AlignBottom
                    horizontalAlignment: Text.AlignLeft

                    color: Theme.onbackground
                    font: Theme.font.body2

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
                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        Text {
            id: warning

            Layout.fillWidth: true
            Layout.preferredHeight: implicitHeight

            textFormat: Text.RichText
            text: qsTr("The program is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.<br>")
            horizontalAlignment: Text.AlignLeft

            color: Theme.onbackground
            font: Theme.font.body2

            wrapMode: Text.WordWrap
        }

        Text {
            id: links

            Layout.fillWidth: true
            Layout.preferredHeight: implicitHeight

            textFormat: Text.RichText
            text: "<style>a:link { color: " + Theme.secondary + ";} </style>"
                  + "<a href='https://www.qt.io/'>https://www.qt.io</a><br>"
                  + "<a href='https://opencv.org/'>https://opencv.org</a><br>"
                  + "<a href='https://itk.org/'>https://itk.org</a><br>"
                  + "<a href='https://fonts.google.com/icons'>https://fonts.google.com/icons</a><br>"
            horizontalAlignment: Text.AlignLeft

            color: Theme.onbackground
            font: Theme.font.caption

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

        Text {
            id: version
            Layout.minimumHeight: implicitHeight
            Layout.fillWidth: true
            Layout.fillHeight: true

            text: "Version " + appVersion
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignRight

            color: Theme.onbackground
            font: Theme.font.caption

            wrapMode: Text.WordWrap
        }
    }
}
