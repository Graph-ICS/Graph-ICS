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
    anchors.leftMargin: 9
    Rectangle{
        color: Theme.textField.color.background.normal
        radius: 1
        height: attributeSwitch.height - 4
        width: attributeSwitch.width - 6
        GSwitchDelegate {
            height: 28
            enabled: !boolAttribute.parent.isInPipeline
            anchors.centerIn: parent
            id: attributeSwitch
            text: boolAttribute.objectName
            checked: boolAttribute.parent.model.getAttributeDefaultValue(boolAttribute.objectName)
            onCheckedChanged: {
                boolAttribute.parent.model.setAttributeValue(boolAttribute.objectName, checked)
            }
            textColorChecked: Theme.textField.color.text.normal
            textColor: Theme.textField.color.text.normal
            switchColor: Theme.textField.color.text.normal
            switchColorChecked: boolAttribute.parent.rect.border.color
        }
    }

    function updateValue(){
        attributeSwitch.checked = parent.model.getAttributeValue(objectName)
    }

    function restoreDefault(){
        attributeSwitch.checked = boolAttribute.parent.model.getAttributeDefaultValue(boolAttribute.objectName)
        boolAttribute.parent.model.setAttributeValue(boolAttribute.objectName, attributeSwitch.checked)
    }
}
