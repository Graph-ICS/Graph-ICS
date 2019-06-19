import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.1

import ".."
import Model.CvSobelOperator 1.0


GFilter {

    property int newText: 0

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

        validator: IntValidator {bottom: 0; top: 2;}

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

        validator: IntValidator {bottom: 0; top: 2;}

        onTextChanged: {
            newText = text.toString();
            model.yDerivative = newText;
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

    //
    MessageDialog {
        id: messageDialog
        title: "Warning"
        text: "The values of the xDerivative and yDerivative must not be both zero."
        onAccepted: {
            messageDialog.close();
        }
        Component.onCompleted: visible = false
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
    function validate() {
        if(model.yDerivative === 0 && model.xDerivative === 0) {
            messageDialog.open();
            return false;
        }
        return true;
    }
}
