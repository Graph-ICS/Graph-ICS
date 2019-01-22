import QtQuick 2.0

GFilter {
    Component.onCompleted: {
        var portIn1 = inPorts[0];
        portIn1.width = 20;
        portIn1.y = + portIn1.viewPort.width;

        var component  = Qt.createComponent("../QML/Port.qml");
        if(component.status === Component.Ready) {
            var portIn2 = component.createObject(gNode);
            if(portIn2 === null) {
                console.log("Error");
            }
        }
        else if(component.status === Component.Error) {
            console.log("Error: ", component.errorString());
        }
        portIn2.x = -portIn1.viewPort.width;
        portIn2.width = portIn1.width;
        portIn2.y = portIn1.y+2*portIn1.viewPort.width+10;
        inPorts.push(portIn2);
    }
}
