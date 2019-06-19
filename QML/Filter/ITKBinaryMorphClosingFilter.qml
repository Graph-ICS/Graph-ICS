import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

import ".."
import Model.ItkBinaryMorphClosing 1.0

GFilter {
    id: gNode

    height: 74
    width: 93

    ItkBinaryMorphClosing {
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
        text: "ItkBinary MorphClosing"
        wrapMode: Text.WordWrap
    }

    TextField {
        id: radius
        x: 46
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

        text: model.radius
        font.family: "Verdana"
        renderType: Text.NativeRendering

         validator: DoubleValidator {bottom: 0; top: 10;}

        onTextChanged: {
            model.radius = text;
        }
    }

    Label {
        x: 5
        y: 50
        color: "#ffffff"
        text: "Radius"
    }
    function saveNode(name) {
        var obj;
        obj = { x: x, y: y,
        objectName : name,
        radius: model.radius};
        return obj;
    }
    function loadNode(nodeData) {
        radius.text  = nodeData.radius;
    }

}
