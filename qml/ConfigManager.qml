import QtQuick 2.0

Item {

    property string favoritesFile: "graphics_favoritesbar_config.json"
    property string settingsFile: "graphics_settings_config.json"

    function saveFavoriteItems() {
        var favoriteItemsNames = []
        var count = favoritesBar.getListSize()

        for (var i = 0; i < count; i++) {
            favoriteItemsNames.push(favoritesBar.getObjectText(i))
        }
        var favoriteItemsJson = JSON.stringify(favoriteItemsNames)
        fileIO.saveFile(favoriteItemsJson, favoritesFile)
    }
    function openFavoriteItems() {
        var fileData = fileIO.openFile(favoritesFile);
        if(fileData === "") {
            favoritesBar.append("Image")
            favoritesBar.append("ItkCannyEdgeDetection")
            favoritesBar.append("CvHistogramEqualization")
        }
        else {
            var favoriteItemsData = JSON.parse(fileData);
            for (var i=0; i<favoriteItemsData.length; i++) {
                favoritesBar.append(favoriteItemsData[i])
            }
        }
    }

    function saveSettings(){
        var jsonData = JSON.stringify(settings.getSettingsConfig())
        fileIO.saveFile(jsonData, settingsFile)
    }

    function loadSettings(){
        var data = fileIO.openFile(settingsFile)
        if(data !== ""){
            settings.setSettingsConfig(JSON.parse(data))
        }
    }

    function loadNodes(data){
        var dataNodes = data

        for (var i = 0; i < dataNodes.length; i++) {
            var nodeData = dataNodes[i];
            var node = createNode(nodeData.objectName)
            node.parent = canvas
            node.x = nodeData.x;
            node.y = nodeData.y;
            canvas.nodes.push(node);
            node.loadNode(nodeData);
        }
    }

    function loadEdges(data) {
        canvas.edges.splice(0, canvas.edges.length); //array ausleeren
        var dataEdges = data
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

            portIn.isConnected = true; // damit man bei geladener Config nicht mehr Linien ziehen kann als erlaubt

            var edge = { "portIn": portIn, "portOut": outNode.portOut };
            edge.portIn.parent.model.addInNode(edge.portOut.parent.model); // damit inNode liste aktualisiert wird
            edge.portOut.parent.model.addOutNode(edge.portIn.parent.model);
            // edge wird erzeugt
            canvas.edges.push(edge);

            canvas.update();
            canvas.requestPaint();
        }
    }

    function loadViewNodeConnection(data){
        data.forEach(function load(viewData){
            canvas.nodes.forEach(function find(node){
                if(viewData.nodeTitle === node.title.title){
                    var view = viewArea.viewAt(viewData.viewIndex)
                    if(view === null){
                        return
                    }
                    view.changeConnectedNode(node)
                    return
                }
            })
        })

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

//        var edgesJson = JSON.stringify(edgesArr);
        return edgesArr;
    }

    function saveNodes(){
        var nodes = [];
        for (var i = 0; i < canvas.nodes.length; i++) {
            var node = canvas.nodes[i];
            var modelName = String(node);
            var buf = modelName.split("_"); // name des Filters wird aus dem String rausgenommen
            var name = buf[0];
            nodes[i] = node.saveNode(name);
        }
        return nodes
    }

    function saveConfig(fileUrl) {
        fileUrl = String(fileUrl)
        // remove prefix (OS specific)
        fileUrl = fileIO.removePathoverhead(fileUrl)

        menuManager.windowTitle = getFileName(fileUrl) //Name des aktuellen Files wird im ApplicationWindow angezeigt
        menuManager.filePath = fileUrl

        var nodes = saveNodes()
        var edges = saveEdges()
        var views = viewArea.saveViewNodeConnection()

        var dataArray = [nodes, edges, views] // put data into array 0:nodes, 1:edges, 2:view connection

        fileIO.saveFile(JSON.stringify(dataArray), fileUrl);
    }

    function openConfig(fileUrl) {
        fileUrl = String(fileUrl)
        // remove prefix (OS specific)
        fileUrl = fileIO.removePathoverhead(fileUrl)

        menuManager.windowTitle = getFileName(fileUrl);//Name des aktuellen Files wird im ApplicationWindow angezeigt
        menuManager.filePath = fileUrl;
        clearConfig();
        var fileData = fileIO.openFile(fileUrl);

//        var dataJson = fileData.split(/(])/);

        var data = JSON.parse(fileData);

        loadNodes(data[0])
        loadEdges(data[1])
        loadViewNodeConnection(data[2])

        resizeCanvas(); // fall eine Konfiguration geöffnet wird, deren Window Size beim speichern unterschiedlich war

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
