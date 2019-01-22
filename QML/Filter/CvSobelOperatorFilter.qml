import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

import ".."
import Model.CvSobelOperator 1.0

GFilter {
    id: gNode

    height: 86
    width: 108

    CvSobelOperator {
        id: model
    }

    property alias model: model

    Label {
        x: 5
        y: 10
        color: "#ffffff"
        font.bold: true
        text: "CvSobelOperator"
    }

    TextField {
        id: xDerivative
        x: 63
        y: 40
        width: 40
        height: 18
        font.pixelSize: 12
        selectByMouse: true
        leftPadding: 6
        rightPadding: 6
        topPadding: 0
        bottomPadding: 0
        horizontalAlignment: "AlignRight"

        text: model.xDerivative
        renderType: Text.NativeRendering

        onTextChanged: {
            model.xDerivative = text;
        }
    }

    TextField {
        id: yDerivative
        x: 63
        y: 60
        width: 40
        height: 18
        font.pixelSize: 12
        selectByMouse: true
        leftPadding: 6
        rightPadding: 6
        topPadding: 0
        bottomPadding: 0
        horizontalAlignment: "AlignRight"

        text: model.yDerivative
        renderType: Text.NativeRendering

        onTextChanged: {
            model.yDerivative = text;
        }
    }

    Label {
        x: 5
        y: 45
        color: "#ffffff"
        text: "xDerivative"
    }

    Label {
        x: 5
        y: 65
        color: "#ffffff"
        text: "yDerivative"
    }
    function saveNode(name) {
        var obj;
        obj = { x: x, y: y,
        objectName : name,
        yDerivative: model.yDerivative,
        xDerivative: model.xDerivative};
        return obj;
    }
    function loadNode(nodeData) {
        xDerivative.text = nodeData.xDerivative;
        yDerivative.text  = nodeData.yDerivative;
    }
}
