import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2

import "../../components/"
import "../../"

import Theme 1.0

// Nur als Child von GNode oder GFilter benutzbar
// Anwendung beim implementieren einer Custom NodeView siehe ItkCannyEdgeDetectionFilter.qml
// oder QmlStringCreator.qml

Item {
    id: rangeAttribute
    anchors.topMargin: 8
    anchors.left: parent.left
    anchors.leftMargin: 9
    width: label.implicitWidth + spinBox.width + 30
    height: /*spinBox.height*/ 24

    GSpinBox {
        id: spinBox
        enabled: !rangeAttribute.parent.isInPipeline
        pressedColor: rangeAttribute.parent.rect.border.color
        value: rangeAttribute.parent.model.getAttributeValue(rangeAttribute.objectName)
        from: rangeAttribute.parent.model.getAttributeConstraint(rangeAttribute.objectName, "minValue")
        to: rangeAttribute.parent.model.getAttributeConstraint(rangeAttribute.objectName, "maxValue")
        stepSize: rangeAttribute.parent.model.getAttributeConstraint(rangeAttribute.objectName, "step")

        onValueChanged: {
            rangeAttribute.parent.model.setAttributeValue(rangeAttribute.objectName, spinBox.value)
        }
    }

    QQC2.Label {
        id: label
        text: rangeAttribute.objectName
        anchors.left: spinBox.right
        anchors.leftMargin: 8
        anchors.verticalCenter: spinBox.verticalCenter
        color: Theme.node.color.text.normal
        font.family: Theme.font.family
        font.pointSize: Theme.font.pointSize
    }

    function updateValue(){
        spinBox.value = parent.model.getAttributeValue(objectName)
        spinBox.from = parent.model.getAttributeConstraint(objectName, "minValue")
        spinBox.to = parent.model.getAttributeConstraint(objectName, "maxValue")
        spinBox.stepSize = parent.model.getAttributeConstraint(objectName, "step")
    }

    function restoreDefault(){
        spinBox.value = parent.model.getAttributeDefaultValue(objectName)
        rangeAttribute.parent.model.setAttributeValue(rangeAttribute.objectName, spinBox.value)
        spinBox.to = rangeAttribute.parent.model.getAttributeConstraint(rangeAttribute.objectName, "maxValue")
        spinBox.from = rangeAttribute.parent.model.getAttributeConstraint(rangeAttribute.objectName, "minValue")
        spinBox.stepSize = rangeAttribute.parent.model.getAttributeConstraint(rangeAttribute.objectName, "step")
        if(rangeAttribute.parent.objectName == "Video"){
            spinBox.from = 0
            spinBox.to = 0
        }
    }

}
