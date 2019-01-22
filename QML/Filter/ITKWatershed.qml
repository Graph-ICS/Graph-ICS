import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

import ".."
import Model.ItkWatershed 1.0

GFilter {
    id: gNode

    height: 86
    width: 91

    ItkWatershed {
        id: model
    }

    property alias model: model

    Label {
        x: 5
        y: 10
        color: "#ffffff"
        font.bold: true
        text: "ITKWatershed"
    }
    TextField {
        id: level
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

        text: model.level
        renderType: Text.NativeRendering

        onTextChanged: {
            model.level = text;
        }
    }
    TextField {
        id: threshold
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

        text: model.threshold
        renderType: Text.NativeRendering

        onTextChanged: {
            model.threshold = text;
        }
    }

    Label {
        x: 5
        y: 65
        color: "#ffffff"
        text: "level"
    }

    Label {
        x: 5
        y: 45
        color: "#ffffff"
        text: "threshold"
    }

    function saveNode(name) {
        var obj;
        obj = { x: x, y: y,
        objectName : name,
        level: level.text,
        threshold: threshold.text};
        return obj;
    }

    function loadNode(nodeData) {
        level.text  = nodeData.level;
        threshold.text  = nodeData.threshold;
    }

}
