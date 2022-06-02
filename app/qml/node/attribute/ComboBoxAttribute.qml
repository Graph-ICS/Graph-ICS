import QtQuick 2.15

import "../../components"

import Theme 1.0
import Global 1.0

GAttribute {
    id: comboBoxAttribute

    property var acceptedStrings: model ? model.getProperty(
                                              "acceptedStrings") : null

    property bool isFillingComboBox: false

    width: comboBox.width + nameText.width

    nameText.anchors.left: comboBox.right
    nameText.anchors.verticalCenter: comboBox.verticalCenter

    onAcceptedStringsChanged: {
        if (acceptedStrings) {
            isFillingComboBox = true
            acceptedStrings.forEach(function (str) {
                comboBox.model.append({
                                          "name": str
                                      })
            })
            isFillingComboBox = false
        }
    }

    GComboBox {
        id: comboBox
        enabled: !isLocked

        width: Math.max(implicitWidth, 82)
        height: parent.height

        defaultFont: comboBoxAttribute.defaultFont

        onCurrentTextChanged: {
            if (!isFillingComboBox) {
                setValue(currentText)
            }
        }
    }

    onValueChanged: {
        for (var i = 0; i < comboBox.model.count; i++) {
            let obj = comboBox.model.get(i)
            if (obj.name === value) {
                comboBox.currentIndex = i
                break
            }
        }
    }
}
