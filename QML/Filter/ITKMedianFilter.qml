import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.1

import ".."
import Model.ItkMedian 1.0

GFilter {
    id: gNode

    height: 86
    width: 91

    ItkMedian {
        id: model
    }

    property alias model: model

    Label {
        x: 5
        y: 10
        color: "#ffffff"
        font.bold: true
        text: "ITKMedian"
    }
    TextField {
        id: radiusY
        x: 48
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

        text: model.radiusY
        renderType: Text.NativeRendering

        validator: IntValidator {bottom: 0; top: 500;}

        onTextChanged: {
            model.radiusY = text;
        }
    }
    TextField {
        id: radiusX
        x: 48
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

        text: model.radiusX
        renderType: Text.NativeRendering

        validator: IntValidator {bottom: 0; top: 500;}

        onTextChanged: {
            model.radiusX = text;
        }
    }

    Label {
        x: 5
        y: 65
        color: "#ffffff"
        text: "RadiusY"
    }

    Label {
        x: 5
        y: 45
        color: "#ffffff"
        text: "RadiusX"
    }
    MessageDialog {
        id: messageDialog
        title: "Warning"
        text: "RadiusX and RadiusY should not be both bigger than 20"
        onAccepted: {
            messageDialog.close();
        }
        Component.onCompleted: visible = false
    }

    function saveNode(name) {
        var obj;
        obj = { x: x, y: y,
        objectName : name,

        radiusX: radiusY.text,
        radiusY: radiusX.text};

        return obj;
    }

    function loadNode(nodeData) {
        radiusY.text  = nodeData.radiusY;
        radiusX.text  = nodeData.radiusX;
    }
    function validate() {
        if(model.radiusY > 20 && model.radiusX > 20) {
            radiusX.validator.top = 10;
            messageDialog.open();
            return false;
        }
        return true;
    }
}
