import QtQuick 2.15
import QtQuick.Controls 2.15

import QtQuick.Dialogs 1.2

import Model.Video 1.0

import "components/"
import "../components/"
import "../"

import Theme 1.0

GNode {

    objectName: model.getNodeName()
    id: video
    property alias model: model

    Video_Model {
        id: model
    }

    title: title

    NodeTitle {
        id: title
    }

    attributes: [
        path, frame, fps
    ]

    NodePathAttribute{
        id: path
        objectName: "path"
        anchors.top: title.bottom
        nameFilters: [ "Video files (*.mp4)", "All files (*)" ]
    }

    NodeRangeAttribute {
        id: frame
        objectName: "frame"
        anchors.top: path.bottom
    }

    NodeDoubleAttribute {
        id: fps
        objectName: "fps"
        anchors.top: frame.bottom
    }

    Connections{
        target: model

        function onCached(value){
            isCached = value;
        }

        function onAttributeValuesUpdated() {
            for(var i = 0; i < attributes.length; i++){
                updateAttributeValues()
            }
        }
    }


    function saveNode() {
        var obj;
        obj = { x: x, y: y, objectName : objectName,
        path: model.getAttributeValue(path.objectName),
        play: model.getAttributeValue(play.objectName),
        frame: model.getAttributeValue(frame.objectName)
        };
        return obj;
    }

    function loadNode(nodeData) {
        for(var i = 0; i < attributes.length; i++){
            model.setAttributeValue(attributes[i].objectName, nodeData[attributes[i].objectName])
        }
        updateAttributeValues()
    }

}

