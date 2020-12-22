import QtQuick 2.15
import QtQuick.Controls 2.15

import ".."
import "components/"

// import the registered Model (Ignore Error Message, because the registering is done at runtime)
import Model.ItkCannyEdgeDetection 1.0

// Automatic Node creation on base of this file
// see QmlStringCreator.qml

GNode {
    id: node

    // This Filter has one input Port
    Port {
        id: portIn
        x: -width + viewPort.width / 2
        y: parent.height / (model.getInPortCount() + 1) - height / 2
        viewPort.x : width - viewPort.width
    }
    // The input Port(s) need to be added to an array
    Component.onCompleted: {
        inPorts.push(portIn);
    }

    // objectName is used to identify the nodes
    // retrieves the m_nodeName specified in the Constructor of the Filter Class
    objectName: model.getNodeName()

    // alias needs to be specified to access the model function from "outside" (make public)
    property alias model: model

    // Instance the backend class
    ItkCannyEdgeDetection_Model{
        id: model
    }

    // Displays the Name of the Node
    // retrieves the Name from the "objectName"
    // title: title; is specified so that in GNode the height and width of the Node can be calculated (if the node has no Attributes)
    title: title
    NodeTitle {
        id: title
    }

    // Array made up of the concrete attributes
    // to calculate the height and width of the Node
    attributes: [variance, upperThreshold, lowerThreshold]

    // Concrete Attribute
    // first Attribute needs to be anchored to the title.bottom
    // the following Attributes need to be anchored to the predecessor attribute
    NodeIntAttribute {
        id: variance
        objectName: "variance"
        // anchors to title
        anchors.top: title.bottom
    }

    NodeIntAttribute {
        id: upperThreshold
        objectName: "upperThreshold"
        // anchor to predecessor Attribute
        anchors.top: variance.bottom
    }

    NodeIntAttribute {
        id: lowerThreshold
        objectName: "lowerThreshold"
        // anchor to predecessor Attribute
        anchors.top: upperThreshold.bottom
    }

    // connect to signals from Backend
    Connections{
        target: model
        // signal to remove the '*' when node is cached
        function onCached(value){
            isCached = value;
        }
        // if the Attributevalues were changed from the backend signalize the frontend to update the values
        function onAttributeValuesUpdated() {
            for(var i = 0; i < attributes.length; i++){
                updateAttributeValues()
            }
        }
    }

    // returns a dictionary with the psoition and the Attributevalues
    function saveNode(name) {
        var obj;
        obj = {
        x: node.x,
        y: node.y,
        objectName : objectName,
        variance: model.getAttributeValue(variance.objectName),
        lowerThreshold: model.getAttributeValue(lowerThreshold.objectName),
        upperThreshold: model.getAttributeValue(upperThreshold.objectName)};
        return obj;
    }

    // gets called when loading the configuration (nodeData is the dictionary returned by the save function)
    function loadNode(nodeData) {
        for(var i = 0; i < attributes.length; i++){
            model.setAttributeValue(attributes[i].objectName, nodeData[attributes[i].objectName])
        }
        updateAttributeValues()
    }
}
