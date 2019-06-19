import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

import ".."
import Model.ItkCannyEdgeDetection 1.0

GFilter {
    id: gNode

    height: 109
    width: 96

    ItkCannyEdgeDetection{
        id: model
    }

    property alias model: model

    Label {
        x: 5
        y: 10
        width: 76
        height: 29
        color: "#ffffff"
        font.bold: true
        text: "ItkCannyEdge Detection"
        wrapMode: Text.WordWrap
    }

    TextField {
        id : variance
        x: 51
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

        validator: IntValidator {bottom: 0; top: 200;}

        onTextChanged: {
            model.variance = text;
        }
    }

    TextField {
        id: upperThreshold
        x: 51
        y: 65
        width: 40
        height: 18
        font.pixelSize: 12
        selectByMouse: true
        leftPadding: 6
        rightPadding: 6
        topPadding: 0
        bottomPadding: 0
        horizontalAlignment: "AlignRight"

        text: model.upperThreshold

        validator: IntValidator {bottom: 0; top: 200;}

        onTextChanged: {
            model.upperThreshold = text;
        }

    }

    TextField {
        id: lowerThreshold
        x: 51
        y: 85
        width: 40
        height: 18
        text: model.lowerThreshold
        font.pixelSize: 12
        bottomPadding: 0
        topPadding: 0
        horizontalAlignment: "AlignRight"
        rightPadding: 6
        selectByMouse: true
        leftPadding: 6

        validator: IntValidator {bottom: 0; top: 200;}

        onTextChanged: {
            model.lowerThreshold = text;
        }
    }

    Label {
        x: 5
        y: 46
        color: "#ffffff"
        text: "Variance"
    }

    Label {
        x: 5
        y: 66
        color: "#ffffff"
        text: "UpperTh"
    }

    Label {
        x: 5
        y: 86
        color: "#ffffff"
        text: "LowerTh"
    }
    function saveNode(name) {
        var obj;
        obj = { x: x, y: y,
        objectName : name,
        variance: model.variance,
        lowerThreshold: model.lowerThreshold,
        upperThreshold: model.upperThreshold};
        return obj;
    }
    function loadNode(nodeData) {
        variance.text  = nodeData.variance;
        lowerThreshold.text = nodeData.lowerThreshold;
        upperThreshold.text = nodeData.upperThreshold;
    }
}
