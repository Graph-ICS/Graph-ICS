import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

import ".."
import Model.ItkDiscreteGaussian 1.0

GFilter {
    id: gNode

    height: 74
    width: 108

    ItkDiscreteGaussian {
        id: model
    }

    property alias model: model

    Label {
        x: 5
        y: 10
        width: 62
        height: 27
        wrapMode: Text.WordWrap
        color: "#ffffff"
        font.bold: true
        text: "Itk DiscreteGaussian"
    }

    TextField {
        id: variance
        x: 56
        y: 45
        width: 40
        height: 18
        font.pixelSize: 12
        selectByMouse: true
        leftPadding: 6
        rightPadding: 6
        topPadding: 0
        bottomPadding: 0
        horizontalAlignment: "AlignRight"

        text: model.variance
        font.family: "Verdana"
        renderType: Text.NativeRendering

        validator: DoubleValidator {bottom: 0; top: 700;}

        onTextChanged: {
            model.variance = text;
        }
    }

    Label {
        x: 5
        y: 48
        color: "#ffffff"
        text: "Variance"
    }
    function saveNode(name) {
        var obj;
        obj = { x: x, y: y,
        objectName : name,
        variance: model.variance};
        return obj;
    }
    function loadNode(nodeData) {
        variance.text = nodeData.variance;
    }

}
