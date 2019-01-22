import QtQuick 2.0

GFilter2Ports {
    Component.onCompleted: {
        var portIn1 = inPorts[0];
        portIn1.width = 10;
        portIn1.y = + parent.y+ portIn1.width;
        var portIn2 = inPorts[1];
        portIn2.width = portIn1.width;
        portIn2.y = portIn1.y+2*portIn1.viewPort.height;

        var component  = Qt.createComponent("../QML/Port.qml");
        if(component.status === Component.Ready) {
            var portIn3 = component.createObject(gNode);
            if(portIn3 === null) {
                console.log("Error");
            }
        }
        else if(component.status === Component.Error) {
            console.log("Error: ", component.errorString());
        }
        portIn3.x = -portIn2.viewPort.width;
        portIn3.width = portIn1.width;
        portIn3.y = portIn2.y+2*portIn2.viewPort.height;
        inPorts.push(portIn3);
    }
}
