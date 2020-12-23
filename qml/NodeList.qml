import QtQuick 2.11


// Liste der Nodes
// wird fuer das SidePanel benutzt

ListModel {
    id: nodes

    Component.onCompleted: {
        // QList der registrierten Nodes
        var nodeList = nodeProvider.getNodeNames()

        // alphabethisch aufsteigend sortieren
        nodeList.sort()

        // in das ListModel einfuegen
        for(var i = 0; i < nodeList.length; i++){
            append({name: nodeList[i]})
        }
    }
}
