import QtQuick 2.0

Item {
    function saveFile(text, fileUrl) {
        var request = new XMLHttpRequest();
        request.open("PUT", fileUrl, false);
        request.send(text);
        return request.status;
    }
    function openFile(fileUrl) {
        var request = new XMLHttpRequest();
        request.open("GET", fileUrl, false);
        request.send(null);
        return request.responseText;
    }
    function loadEdges(edgesJson) {
        canvas.edges.splice(0, canvas.edges.length); //array ausleeren
        var dataEdges = JSON.parse(edgesJson);
        for (var i = 0; i < dataEdges.length; i++) {
            var edgesData = dataEdges[i];
            var indexInode = edgesData.inNodeIndex; //index des inNodes wird ausgelesen
            var indexOutNode = edgesData.outNodeIndex; //index des outNodes wird ausgelesen
            var indexPortIn = edgesData.portInIndex;

            var inNode = canvas.nodes[indexInode]; // knoten wird aus dem nodesArray anhand des inNodes rausgesucht
            var outNode = canvas.nodes[indexOutNode];
            var portIn = inNode.inPorts[indexPortIn];

            // richtige Farben der ports setzen
            outNode.portOut.viewPort.color = canvas.edgeColor;
            portIn.viewPort.color = canvas.edgeColor;
            outNode.portOut.defaultColor = canvas.edgeColor;
            portIn.defaultColor = canvas.edgeColor;

            var edge = { "portIn": portIn, "portOut": outNode.portOut };
            edge.portIn.parent.model.addInNode(edge.portOut.parent.model); // damit inNode liste aktualisiert wird
            edge.portOut.parent.model.addOutNode(edge.portIn.parent.model);
            // edge wird erzeugt
            canvas.edges.push(edge);

            canvas.update();
            canvas.requestPaint();
        }
    }
    function saveEdges() {
        var edgesArr = [];
        for (var i = 0; i < canvas.edges.length; i++) {
            var edge = canvas.edges[i];

            var portInIndex = edge.portIn.parent.inPorts.indexOf(edge.portIn);
            var inNodeIndex = canvas.nodes.indexOf(edge.portIn.parent);
            var outNodeIndex = canvas.nodes.indexOf(edge.portOut.parent);
            var obj = {outNodeIndex: outNodeIndex,
                inNodeIndex: inNodeIndex,
                portInIndex: portInIndex};
            edgesArr[i] = obj;
        }
        var edgesJson = JSON.stringify(edgesArr);
        return edgesJson;
    }
    function saveConfig(fileUrl) {
        menuManager.windowTitle = getFileName(fileUrl);//Name des aktuellen Files wird im ApplicationWindow angezeigt
        menuManager.filePath = fileUrl;
        var obj_node = [];
        for (var i = 0; i < canvas.nodes.length; i++) {
            var node = canvas.nodes[i];
            var modelName = String(node);
            var buf = modelName.split("_"); // name des Filters wird aus dem String rausgenommen
            var name = buf[0];
            obj_node[i] = node.saveNode(name);
        }
        var nodesJson = JSON.stringify(obj_node); // alle Daten der Knoten
        var edgesJson = configManager.saveEdges(); // Daten der Kanten
        var dataJson = nodesJson + edgesJson; // Trennzeichen eingefügt, um Daten der Konten und der Kanten zu trennen
        saveFile(dataJson, fileUrl);
    }
    function saveToolBarItems() {
        var toolbarItemsNames = [];
        for (var i=0; i<toolBar.toolbarItems.length; i++) {
            toolbarItemsNames.push(toolBar.toolbarItems[i].label.text);
        }
        var toolbarItemsJson = JSON.stringify(toolbarItemsNames);
        saveFile(toolbarItemsJson, "../configuration.txt");
    }
    function openToolBarItems() {
        var fileData = openFile("../configuration.txt");
        var dataToolbarItems = JSON.parse(fileData);
        for (var i=0; i<dataToolbarItems.length; i++) {
            var component = Qt.createComponent("ToolBarItem.qml");
            var item = component.createObject(toolBar.comboBox);
            item.label.text = dataToolbarItems[i];
            var text = String(dataToolbarItems[i]);
            item.width = text.length*7.5;
            toolBar.toolbarItems.push(item);
            item.drawToolbarItems();
        }
    }

    function openConfig(fileUrl) {
        menuManager.windowTitle = getFileName(fileUrl);//Name des aktuellen Files wird im ApplicationWindow angezeigt
        menuManager.filePath = fileUrl;
        clearConfig();
        var fileData = openFile(fileUrl);
        var dataJson = fileData.split(/(])/);
        var nodesJson = dataJson[0]+dataJson[1]; //Daten der Knoten
        var edgesJson = dataJson[2]+dataJson[3]; //Daten der Kanten
        var dataNodes = JSON.parse(nodesJson);
        for (var i = 0; i < dataNodes.length; i++) {
            var nodeData = dataNodes[i];
            if (nodeData.objectName === "Image") {
                var component = Qt.createComponent(nodeData.objectName + ".qml");
                var image = component.createObject(canvas);
                image.x = nodeData.x;
                image.y = nodeData.y;
                canvas.nodes.push(image);
                image.loadNode(nodeData);
            }
            else {
                var component2 = Qt.createComponent("filter/" + nodeData.objectName + ".qml");
                var node = component2.createObject(canvas);
                node.x = nodeData.x;
                node.y = nodeData.y;
                canvas.nodes.push(node);
                node.loadNode(nodeData);
            }
        }
        loadEdges(edgesJson);

        resizeImageView(); // fall eine Konfiguration geöffnet wird, deren Window Size beim speichern unterschiedlich war

    }
    function clearConfig() {
        var counter = canvas.nodes.length; // da node.length immer kleiner wird
        for (var i = 0; i < counter; i++) {
            var node = canvas.nodes[0];
            canvas.removeNode(node);
        }
        for (var j; j < canvas.edges.length; j++) {
            canvas.removeEdge(j);
        }
    }
    function getFileName(fileUrl) {
        var filePath = String(fileUrl);
        var buf = filePath.split("/");
        var fileName = buf[buf.length-1]; // Name des Files ohne den ganzen Pfad, der dann im Titel angezeigt werden kann
        return fileName;
    }
}
