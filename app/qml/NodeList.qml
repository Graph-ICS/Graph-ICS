import QtQuick 2.11

// Liste der Nodes
// wird fuer das SidePanel benutzt
ListModel {
    id: nodes

    signal nodesAdded

    Component.onCompleted: {
        var nodeList = nodeProvider.getNodeNames()
        nodeList.sort()
        for (var i = 0; i < nodeList.length; i++) {
            append({
                       "name": nodeList[i]
                   })
        }
        nodesAdded()
    }
}
