import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2

import "../../components/"
import "../../"

import Theme 1.0

// Nur als Child von GNode oder GFilter benutzbar
// Anwendung beim implementieren einer Custom NodeView siehe ItkCannyEdgeDetectionFilter.qml
// oder QmlStringCreator.qml

Item {
    id: intAttribute

    width: label.implicitWidth + textField.implicitWidth + 28
    height: /*textField.height*/ 24
    anchors.topMargin: 8
    anchors.left: parent.left
    anchors.leftMargin: 9

    GTextField {
        id: textField
        enabled: !intAttribute.parent.isInPipeline
        horizontalAlignment: TextInput.AlignHCenter
        width: implicitWidth
        height: font.pointSize + 16
        font.family: Theme.font.family
        font.pointSize: Theme.font.pointSize
        maximumLength: 4
        validator: IntValidator {
            locale: "en"
        }
        borderColor: intAttribute.parent.rect.border.color
        text: intAttribute.parent.model.getAttributeDefaultValue(intAttribute.objectName)
        onAccepted: {
            validateValue()
        }
        onFocusChanged: {
            validateValue()
        }
        onWidthChanged: {
            intAttribute.parent.rect.updateNodeWidth()
        }
    }

    QQC2.Label {
        id: label
        text: intAttribute.objectName
        anchors.left: textField.right
        anchors.leftMargin: 8
        anchors.verticalCenter: textField.verticalCenter
        color: Theme.node.color.text.normal
        font.family: Theme.font.family
        font.pointSize: Theme.font.pointSize
    }

    // wird in processNode fuer jedes Attribut aufgerufen
    // die Attribut Werte werden in das Backend geladen, dort validiert und
    // zur Anzeige in den Text Feldern zurueck geholt
    function validateValue(){
        if(textField.text === ""){
            textField.text = parent.model.getAttributeDefaultValue(objectName)
        }
        parent.model.setAttributeValue(objectName, parseInt(textField.text))
        textField.text = parent.model.getAttributeValue(objectName)
    }

    function updateValue(){
        textField.text = parent.model.getAttributeValue(objectName)
    }

    function restoreDefault(){
        textField.text = parent.model.getAttributeDefaultValue(objectName)
        parent.model.setAttributeValue(objectName, parseInt(textField.text))
    }

}
