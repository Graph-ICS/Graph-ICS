import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2

import "../../components/"
import "../../"

import Theme 1.0

// Nur als Child von GNode oder GFilter benutzbar
// Anwendung beim implementieren einer Custom NodeView siehe ItkCannyEdgeDetectionFilter.qml
// oder QmlStringCreator.qml

Item {
    id: comboBoxAttribute

    width: comboBox.implicitWidth > 85 ? comboBox.implicitWidth + label.implicitWidth + 28 : 85 + label.implicitWidth + 28
    height: 24
    anchors.topMargin: 8
    anchors.left: parent.left
    anchors.leftMargin: 9

    GComboBox {
        id: comboBox
        width: implicitWidth > 85 ? implicitWidth : 85
        enabled: !comboBoxAttribute.parent.isInPipeline
        Component.onCompleted: {
            fillModel()
        }

        function fillModel(){
            var size = comboBoxAttribute.parent.model.getAttributeConstraint(comboBoxAttribute.objectName, "size")
            for(var i = 0; i < size; i++){
                var item = comboBoxAttribute.parent.model.getAttributeConstraint(comboBoxAttribute.objectName, String(i))
                model.append({"name": item})
            }
            currentIndex = 0
        }
        onCurrentTextChanged: {
            comboBoxAttribute.parent.model.setAttributeValue(comboBoxAttribute.objectName, comboBox.currentText)
        }
        onWidthChanged: {
            comboBoxAttribute.parent.rect.updateNodeWidth()
        }
    }

    QQC2.Label {
        id: label
        text: comboBoxAttribute.objectName
        anchors.left: comboBox.right
        anchors.leftMargin: 8
        anchors.verticalCenter: comboBox.verticalCenter
        color: Theme.node.color.text.normal
        font.family: Theme.font.family
        font.pointSize: Theme.font.pointSize
    }

    function validateValue(){

    }

    function updateValue(){
        var val = comboBoxAttribute.parent.model.getAttributeValue(comboBoxAttribute.objectName)
        for(var i = 0; i < comboBox.model.count; i++){
            var item = comboBox.model.get(i)
            if(item === val){
                comboBox.currentIndex = i
                break
            }
        }
    }

    function restoreDefault(){
        comboBox.currentIndex = 0
        comboBoxAttribute.parent.model.setAttributeValue(comboBoxAttribute.objectName, comboBox.currentIndex)
    }
}
