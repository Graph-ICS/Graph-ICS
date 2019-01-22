import QtQuick 2.0

GNode {
    id: gFilter
    Port {
        id: portIn
        x: -width
        viewPort.x : width - viewPort.width
    }
    Component.onCompleted: {
        inPorts.unshift(portIn);
    }
}
