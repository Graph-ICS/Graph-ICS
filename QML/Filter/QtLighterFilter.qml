import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

import ".."
import Model.QtLighterFilter 1.0

GFilter {
    id: gNode

    height: 74
    width: 93

    QtLighterFilter {
        id: model
    }

    property alias model: model

    Label {
        x: 5
        y: 10
        color: "#ffffff"
        font.bold: true
        text: "Lighter"
    }

    TextField {
        id: factor
        x: 44
        y: 48
        width: 40
        height: 18
        font.pixelSize: 12
        selectByMouse: true
        leftPadding: 6
        rightPadding: 6
        topPadding: 0
        bottomPadding: 0
        horizontalAlignment: "AlignRight"

        text: model.factor

        onTextChanged: {
            model.factor = text;
        }

        validator: IntValidator {
            bottom: 0
            top: 9999
        }
    }

    Label {
        x: 5
        y: 50
        color: "#ffffff"
        text: "Factor"
    }
    function saveNode(name) {
        var obj;
        obj = { x:x, y:y,
        objectName : name, index: model.index,
        value: model.factor};
        return obj;
    }
    function loadNode(nodeData) {
        factor.text = nodeData.value;
    }
}
