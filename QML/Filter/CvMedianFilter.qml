import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

import ".."
import Model.CvMedianFilter 1.0

GFilter {
    id: gNode

    width: 90

    CvMedianFilter {
        id: model
    }

    property alias model: model

    Label {
        x: 5
        y: 10
        color: "#ffffff"
        font.bold: true
        text: "CvMedian"
    }

    Label {
        x: 5
        y: 31
        color: "#ffffff"
        text: "Kernel size:"
    }

    SpinBox {
        id: spinbox
        x: -5
        y: 47
        width: 100
        height: 20
        padding: 0
        rightPadding: 39
        spacing: -2
        scale: 0.8
        wheelEnabled: true
        font.pointSize: 7
        font.family: "Verdana"
        editable: true
        from: 1
        stepSize: 2
        value: model.kernelSize

        onValueChanged:  {
            model.kernelSize = spinbox.value;
        }
    }
    function saveNode(name) {
        var obj;
        obj = { x: x, y: y,
        objectName : name,
        kernelSize: model.kernelSize,};
        return obj;
    }
    function loadNode(nodeData) {
        spinbox.value  = nodeData.kernelSize;
    }

}
