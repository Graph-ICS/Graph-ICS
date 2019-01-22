import QtQuick 2.0

import QtQuick 2.10
import QtQuick.Controls 2.4
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

import QtQuick.Window 2.11
import QtQuick.Extras 1.4

import QtQuick.Controls 2.2




Window {
    minimumWidth: 600;
    maximumWidth: 600;
    minimumHeight: 600;
    maximumHeight: 600;
    color: "white"
    modality: Qt.WindowModal

    ListModel {
        id: model

    }
    Label {
        x: 128
        y: 34
        text: "Fiter:"
        font.pixelSize: 20

    }
    Button {
        x: 197
        y: 34
        text: "Add Filter"
        onClicked: {
            model.append( { "name":  "Item" + model.count })
        }
    }
    Button {
        x: 485
        y: 34
        text: "Remove all Items"
        onClicked: {
            model.clear();
        }
    }

    ScrollView {
        id: scrollView1
        x: 310
        y: 100
        width: 277
        height: 374
        ListView {
            anchors.centerIn: parent

            model: model

            delegate: Rectangle {
                width: scrollView1.width;
                height: 50
                border.width: 1
                border.color: "white"
                color: "gainsboro"
                Text {
                    anchors.centerIn: parent
                    text: name
                }
            }

            add: Transition {
                NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 100 }
                NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 100 }
            }

            displaced: Transition {
                NumberAnimation { properties: "x,y"; duration: 100; easing.type: Easing.OutBounce }
            }

            focus: true
            Keys.onSpacePressed: model.insert(0, { "name":  "Item" + model.count })
        }
    }
    Label {
        x: 366
        y: 42
        text: "Favoriten: "
        font.pixelSize: 20

    }
    ListModel {
        id: myModel
        ListElement {
            name: "Image"
        }
        ListElement {
            name: "QtBlackWhiteFilter"
        }
        ListElement {
            name: "QtLighterFilter"
        }
        ListElement {
            name: "QtDarkerFilter"
        }
        ListElement {
            name: "ITKMedianFilter"
        }
        ListElement {
            name: "ITKDiscreteGaussianFilter"
        }
        ListElement {
            name: "ITKCannyEdgeDetectionFilter"
        }
        ListElement {
            name: "ITKBinaryMorphClosingFilter"
        }
        ListElement {
            name: "ITKBinaryMorphOpeningFilter"
        }
        ListElement {
            name: "ITKSubstractFilter"
        }
        ListElement {
            name: "CvMedianFilter"
        }
        ListElement {
            name: "CvSobelOperatorFilter"
        }
    }
    ScrollView {
        x: 20
        y: 100
        width: 277
        height: 374
        Layout.fillWidth: true
        Layout.fillHeight: true
        ListView {
            id: listView
            anchors.leftMargin: 46
            anchors.topMargin: 0
            anchors.rightMargin: -46
            anchors.bottomMargin: -63
            model: myModel
            delegate:
                Rectangle {
                property bool isSelected: false
                width: parent.width;
                height: 50
                border.width: 1
                border.color: "white"
                color: "gainsboro"
                Text {
                    //anchors.centerIn: parent
                    x: parent.x + 20
                    y: +18
                    text: name
                }
                MouseArea {
                    width: parent.width
                    height: parent.height
                    onClicked: {
                        if(parent.isSelected === false) {
                            parent.border.color = "orange"
                            parent.isSelected = true;
                            button.rect.color = "yellow"
                        }
                        else {
                            parent.border.color = "white";
                            parent.isSelected = false;
                        }
                    }
                }

                Button {
                    id: button
                    height: parent.height/2
                    width: height
                    background: Rectangle {
                        id: rect
                        width: parent.width
                        height: parent.height
                        color: "transparent"
                    }
                    y: +15
                    x: + 220
                    Image{
                        width: parent.width-2
                        height: parent.height-2
                        anchors.centerIn: parent
                        source: "../doc/star4.png"
                    }
                    onClicked: {
                        model.append( { "name":  "Item" + model.count })
                    }

                }

            }
        }
    }
}


/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
