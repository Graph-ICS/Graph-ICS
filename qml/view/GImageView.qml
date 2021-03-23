import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15

import Theme 1.0
import "../"
import "../components/"

Rectangle {
    id: imageRect
    color: Theme.mainColor

    property alias image: imageView

    MouseArea {
        id: mouseArea
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        anchors.fill: parent

        Image {
            id: imageView
            z: -2
//            anchors.verticalCenterOffset: -Theme.contentDelegate.height
            states: [
                State {
                    name: "scale"
                    AnchorChanges {
                        target: imageView
                        anchors.left: mouseArea.left
                        anchors.right: mouseArea.right
                        anchors.top: mouseArea.top
                        anchors.bottom: mouseArea.bottom
                    }
                },
                State {
                    name: "normal"
                    AnchorChanges {
                        target: imageView
                        anchors.horizontalCenter: mouseArea.horizontalCenter
                        anchors.verticalCenter: mouseArea.verticalCenter
                    }
                }
            ]

            width: parent.width
            height: parent.height
            state: 'scale'
            cache: false
            property int counter : 0
//            source: "image://gimg/" + counter
            fillMode: Image.PreserveAspectFit

            function reload() {
                counter++;
                source= "image://gimg/" + counter;
                height = parent.height
            }
            function reloadNewImage(path) {
                source = path;
            }
            function removeImage()
            {
                gImageProvider.removeImg()
                source = "";
            }
        }
        onClicked: {
//            forceActiveFocus()
//            if (mouse.button === Qt.RightButton)
//                viewerContextMenu.popup()
        }
//        GMenu {
//            id: viewerContextMenu
//            QQC2.Action {
//                text: "Clear Image"
//                onTriggered: {

//                }
//                enabled: menuManager.isClearImageAllowed()
//            }
//            QQC2.Action {
//                text: "Save Image As"
//                onTriggered: {
//                    menuBar.fileDialog.open("save_image")
//                }
//                enabled: menuManager.isSaveImageAsAllowed()

//            }
//            QQC2.Action {
//                text: "Export Video"
//                onTriggered: {
//                    menuBar.exportDialog.nodeToExport = canvas.getShownImageNode()
//                    menuBar.exportDialog.showNormal()
//                }
//                enabled: menuManager.isExportVideoAllowed()
//            }
//        }
    }

    function reload(){
        imageView.reload()
    }

    function reloadNewImage(){
        imageView.reloadNewImage()
    }

    function removeImage(){
        imageView.removeImage()
    }
    function setState(state){
        imageView.state = state
    }

    function setImage(img){
        gImageProvider.img = img
        imageView.reload()
    }
}
