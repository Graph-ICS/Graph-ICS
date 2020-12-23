import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.12

import "../../components/"
import Theme 1.0

// Nur als Child von GNode oder GFilter benutzbar
// Anwendung beim implementieren einer Custom NodeView siehe ItkCannyEdgeDetectionFilter.qml
// oder QmlStringCreator.qml

Item {
    id: pathAttribute
    height: /*textField.height*/ 24
    width: textField.width + fileButton.width + 14

    property var nameFilters: []

    anchors.topMargin: 8
    anchors.left: parent.left
    anchors.leftMargin: 9

    GTextField {
        id: textField
        enabled: !pathAttribute.parent.isInPipeline
        width: 75
        height: font.pointSize + 16
        font.pointSize: Theme.font.pointSize
        font.family: Theme.font.family
        borderColor: pathAttribute.parent.rect.border.color

        placeholderText: pathAttribute.objectName
        text: pathAttribute.parent.model.getAttributeValue(pathAttribute.objectName)
        onTextChanged: {
            pathAttribute.parent.model.setAttributeValue(pathAttribute.objectName, text)
        }

        Keys.onReturnPressed: {
            pathAttribute.parent.processNode()
        }
    }

    GFileButton {
        id: fileButton
        enabled: !pathAttribute.parent.isInPipeline
        anchors{
            left: textField.right
            verticalCenter: textField.verticalCenter
        }
        nameFilters: pathAttribute.nameFilters
        onAccepted: {
            var path = String(fileUrl)
            pathAttribute.parent.model.setAttributeValue(pathAttribute.objectName, path)
            textField.text = pathAttribute.parent.model.getAttributeValue(pathAttribute.objectName)
        }
    }

    function updateValue(){
        textField.text = parent.model.getAttributeValue(objectName)
    }

    function restoreDefault(){
        textField.text = parent.model.getAttributeDefaultValue(objectName)
    }
}
