import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2

import "../../components/"
import "../../"

import Theme 1.0

// Nur als Child von GNode oder GFilter benutzbar
// Anwendung beim implementieren einer Custom NodeView siehe ItkCannyEdgeDetectionFilter.qml
// oder QmlStringCreator.qml

Item {
    id: boolAttribute
    width: attributeSwitch.width + 13
    height: /*attributeSwitch.height - 4*/ 24
    anchors.topMargin: 8
    anchors.left: parent.left
    anchors.leftMargin: 0

    QQC2.Label {
        id: attributeName
        anchors.left: attributeSwitch.right
//        anchors.leftMargin: 6
        anchors.verticalCenter: attributeSwitch.verticalCenter
        text: boolAttribute.objectName
        font.pointSize: Theme.font.pointSize
        font.family: Theme.font.family
        color: Theme.node.color.text.normal
    }

    GSwitch {
        id: attributeSwitch
        height: 28
        enabled: !boolAttribute.parent.isInPipeline
        anchors.left: boolAttribute.left
        anchors.verticalCenter: boolAttribute.verticalCenter


        checked: boolAttribute.parent.model.getAttributeDefaultValue(boolAttribute.objectName)
        onCheckedChanged: {
            boolAttribute.parent.model.setAttributeValue(boolAttribute.objectName, checked)
        }
        textColorChecked: /*Theme.textField.color.text.normal*/ Theme.node.color.text.normal
        textColor: /*Theme.textField.color.text.normal*/ Theme.node.color.text.normal
        switchColor: /*Theme.textField.color.text.normal*/ Theme.node.color.text.normal
        switchColorChecked: boolAttribute.parent.rect.border.color
    }

    function updateValue(){
        attributeSwitch.checked = parent.model.getAttributeValue(objectName)
    }

    function restoreDefault(){
        attributeSwitch.checked = boolAttribute.parent.model.getAttributeDefaultValue(boolAttribute.objectName)
        boolAttribute.parent.model.setAttributeValue(boolAttribute.objectName, attributeSwitch.checked)
    }
}
