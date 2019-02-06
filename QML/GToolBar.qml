import QtQuick 2.10
import QtQuick.Controls 2.4

import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4



RowLayout {
    id: toolBar
    property var toolbarCombobox: comboBox
    property alias selectedItem: chosenItemText.text;
    property var toolbarItems: []
    property alias filters: filters
    property alias comboBox: comboBox
    property alias selectButton: selectButton
    height: 40

    Rectangle {
        id:comboBox

        property alias selectedIndex: listView.currentIndex;
        signal comboClicked;
        width: 280;
        height: parent.height;

        Rectangle { // das Item, dass in der Combo Box ganz oben steht
            id:chosenItem
            width:parent.width;
            height:comboBox.height;
            color: "light grey"
            smooth:true;
            border.width : 1
            border.color: "lightgray"
            Text {
                anchors.centerIn: parent
                id:chosenItemText
                text: filters.get(0).name;
                font.family: "Arial"
                font.pointSize: 13;
            }

            MouseArea {
                anchors.rightMargin: 0
                anchors.bottomMargin: 6
                anchors.fill: parent;
                onClicked: {
                    comboBox.state = comboBox.state==="dropDown"?"":"dropDown"
                }
            }
        }

        Rectangle {  // das Rechteck, dass die anderen Einträge enthält
            id:dropDown
            width:comboBox.width;
            height: 0;
            clip:true;
            anchors.top: chosenItem.bottom;
            color: "gainsboro"
            radius: 2


            ListView {
                id:listView
                ScrollBar.vertical: ScrollBar {
                    active: true
                }

                height: root.height;
                model: filters
                currentIndex: 0
                delegate: ComoBoxItem {}
            }
        }
        states: State {
            name: "dropDown";
            PropertyChanges { target: dropDown; height:40*filters.count }
        }
        transitions: Transition {
            NumberAnimation { target: dropDown; properties: "height"; easing.type: Easing.OutExpo; duration: 650 }
        }
    }
    Button {
        id: selectButton
        x: 398
        y: 0
        width: 89
        height: 49
        text: "Select"

        MouseArea {
            anchors.fill: parent
            onPressed: {
                canvas.resetSelectedNodes(); // Knoten Markierungen entfernen
            }

            onReleased: {
                if(chosenItemText.text === "Image"){
                    createNode(selectedItem, mouseX, mouseY, parent.parent.parent.x + parent.x, height);
                }
                else{
                    createFilter(selectedItem, mouseX, mouseY, parent.parent.parent.x + parent.x, height);
                }
            }
        }
    }
    ListModel {
        id: filters
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
            name: "ITKCannyEdgeDetectionFilter"
        }
        ListElement {
            name: "ITKDiscreteGaussianFilter"
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
        //        ListElement {
        //            name: "ITKWatershed"
        //        }
    }

}

