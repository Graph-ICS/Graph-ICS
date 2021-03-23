import QtQuick 2.15
import QtQuick.Controls 1.2

import Theme 1.0

//todo, alle funtionen von mousarea nach canvas verschieben

//Flickable {
//    width: 300
//    height: 300
//    interactive: true


//    Rectangle{
//        width: parent.width
//        height: parent.height
//        color: "red"

Canvas {
    id: canvas
    height: parent.height
    width: parent.width
    anchors.centerIn: parent
    focus: true

    Keys.onPressed: {
        if (event.key === Qt.Key_Control) {
            isKeyPressed = true;
        }
    }
    Keys.onReleased: {
        if (event.key === Qt.Key_Control) {
            isKeyPressed = false;
        }
    }

    readonly property string hoverColor: Theme.canvas.color.edge.hover
    readonly property string edgeColor: Theme.canvas.color.edge.normal

    readonly property string selectColor: Theme.node.color.border.select

    property alias mouseArea: mouseArea

    property var nodes: []
    property var edges: []

    property int hoveredEdge: -1

    property int edgeFromX: 0
    property int edgeFromY: 0
    property int edgeToX: 0
    property int edgeToY: 0

    property double mx:0
    property double my:0
    property double lastx:0.0
    property double lasty:0.0
    // flag
    property bool drawing:false
    property bool isKeyPressed: false

    property var hoveredFromPort: null  // wichtig für if Abfrage
    property var hoveredToPort: null

    property bool toPortHovered: false

    property int minimumX: 0 // für das Verschieben mehrerer markierter Knoten


    onPaint: {
        var ctx = getContext("2d");

        ctx.fillStyle = Theme.canvas.color.background.normal

        ctx.fillRect(0, 0, width, height);

        ctx.lineWidth = 2;
        ctx.strokeStyle = edgeColor;

        ctx.beginPath();
        ctx.moveTo(edgeFromX, edgeFromY);
        ctx.lineTo(edgeToX, edgeToY);
        ctx.stroke();

        for (var i = 0; i < edges.length; i++) {
            var edge = edges[i];

            if (hoveredEdge === i) {
                ctx.strokeStyle = canvas.hoverColor;
            }
            else {
                ctx.strokeStyle = canvas.edgeColor;
            }

            ctx.beginPath();

            var fromX = edge.portOut.viewPort.absCenterX;
            var fromY = edge.portOut.viewPort.absCenterY;

            var toX = edge.portIn.viewPort.absCenterX;
            var toY = edge.portIn.viewPort.absCenterY;

            ctx.moveTo(fromX, fromY);
            ctx.lineTo(toX, toY);
            ctx.stroke();
        }
        // Zum Ziehen der Rechtecke: überprüfen ob sich mouse gerade auf einem Port befindet
        if(hoveredFromPort === null && hoveredToPort === null) {
            ctx.lineWidth = 1
            ctx.strokeStyle = Theme.canvas.color.stroke.normal
            ctx.clearRect (0, 0, 0, 0);
            if(drawing)
                ctx.strokeRect(lastx,lasty,mx-lastx,my-lasty);
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        readonly property int _left: 0
        readonly property int _center: 1
        readonly property int _right: 2

        property int hoveredEdgeArea: _left // 0 = left, 1 = center, 2 = right

        onPressed: {
            forceActiveFocus()
            if (mouse.button === Qt.LeftButton && hoveredFromPort == null && hoveredToPort == null && hoveredEdge === -1)
            {
                canvas.lastx=mouse.x;
                canvas.lasty=mouse.y;
                canvas.drawing=true
            }
            if (hoveredFromPort != null) {
                hoveredFromPort.viewPort.color = canvas.edgeColor;
            }
            else if (canvas.hoveredEdge >= 0 && hoveredEdgeArea != _center) {

                var otherPort;

                if (hoveredEdgeArea == _left) {
                    hoveredFromPort = canvas.edges[canvas.hoveredEdge].portIn;
                    hoveredFromPort.viewPort.color = canvas.edgeColor;
                    otherPort = canvas.edges[canvas.hoveredEdge].portOut;
                }
                else {
                    hoveredFromPort = canvas.edges[canvas.hoveredEdge].portOut;
                    hoveredFromPort.viewPort.color = canvas.edgeColor;
                    otherPort = canvas.edges[canvas.hoveredEdge].portIn;
                }

                removeEdge(canvas.hoveredEdge)

                canvas.hoveredEdge = -1;


                updatePortColor(otherPort);

                positionChanged(mouse);
            }
        }

        onReleased: {

            resetSelectedNodes();
            if(canvas.lastx === mouse.x && canvas.lasty === mouse.y) {
                drawing = false;
            }

            if(hoveredFromPort == null && hoveredToPort == null && hoveredEdge === -1 && drawing === true) {
                canvas.requestPaint();
                canvas.drawing = false;
                markSelectedNodes();
            }

            if (hoveredFromPort != null) {

                canvas.edgeFromX = 0;
                canvas.edgeFromY = 0;
                canvas.edgeToX = 0;
                canvas.edgeToY = 0;

                if (hoveredToPort != null && isEdgeAllowed(hoveredToPort) === true) { // draw Edge
                    canvas.addEdge(retrieveEdge(hoveredToPort));
                    hoveredFromPort.defaultColor = canvas.edgeColor;
                    hoveredToPort.defaultColor = canvas.edgeColor;
                    hoveredToPort = null;
                }
                else {
                    updatePortColor(hoveredFromPort);
                    canvas.update();
                    canvas.requestPaint();
                }

                hoveredFromPort = null;
                hoveredToPort = null;


            }
            else if (canvas.hoveredEdge >= 0 && hoveredEdgeArea == _center) {
                var edge = canvas.removeEdge(canvas.hoveredEdge);
                if(edge === null){
                    // falls edge zur Pipeline gehoert
                    return
                }

                updatePortColor(edge.portOut);

                updatePortColor(edge.portIn);
                canvas.hoveredEdge = -1;

                canvas.update();
                canvas.requestPaint();
            }
        }

        onExited: {
            if (!pressed && hoveredFromPort != null) {
                hoveredFromPort.viewPort.color = hoveredFromPort.defaultColor;
                hoveredFromPort = null;
            }
        }
        onPositionChanged: {
//            console.log("mouseArea: ", mouseX);
//            for( var n=0; n<toolBar.toolbarItems.length; n++) {
//                var item = toolBar.toolbarItems[n];
//                console.log("item.x ", item.x);
//                if(mouseX > item.x) {
//                    swap(toolBar.toolbarItems, 1,0);
//                    break;
//                }
//            }
//            var pos = 386;
//            for( var i=0; i<toolBar.toolbarItems.length; i++) {
//                var item2 = toolBar.toolbarItems[i];
//                item2.x = pos;
//                pos = pos+item2.width+1;
//            }
            if(hoveredFromPort == null && hoveredToPort == null) {
                canvas.mx=mouse.x;
                canvas.my=mouse.y;
                if(canvas.drawing)
                    canvas.requestPaint();
            }

            var i;

            if (!pressed) {

                // consider hover ports

                var hoveredPort = null;

                nodesLoop: for (i = 0; i < canvas.nodes.length; i++) {

                    var node = canvas.nodes[i];
                    for(var j=0; j<node.inPorts.length; j++) {

                        if (node.inPorts[j].isHovered) {
                            hoveredPort = node.inPorts[j];
                            break nodesLoop;
                        }
                    }
                    if (node.portOut.isHovered) {
                        hoveredPort = node.portOut;
                        break;
                    }
                }

                if (hoveredFromPort !== hoveredPort) {


                    if (hoveredPort !== null) {
                        hoveredPort.viewPort.color = canvas.hoverColor;
                    }

                    if (hoveredFromPort != null) {
                        hoveredFromPort.resetColor();
                    }

                    hoveredFromPort = hoveredPort;
                }

                if (hoveredPort !== null) {

                    if (canvas.hoveredEdge >= 0) {

                        var edgePort = canvas.edges[canvas.hoveredEdge].portOut;

                        if (edgePort !== hoveredPort) {
                            edgePort.resetColor();
                        }

                        edgePort =  canvas.edges[canvas.hoveredEdge].portIn;

                        if (edgePort !== hoveredPort) {
                            edgePort.resetColor();
                        }

                        canvas.hoveredEdge = -1;

                        canvas.update();
                        canvas.requestPaint();
                    }

                    return;
                }

                // consider hover edges

                var updateNeeded = false;
                var hovered = false;

                for (i = 0; i < canvas.edges.length; i++) {
                    var edge = canvas.edges[i];

                    var fromX = edge.portOut.viewPort.absCenterX;
                    var fromY = edge.portOut.viewPort.absCenterY;
                    var toX = edge.portIn.viewPort.absCenterX;
                    var toY = edge.portIn.viewPort.absCenterY;

                    if (!inRect(fromX, toX, fromY, toY)) {
                        continue;
                    }

                    var a = (toY - fromY) / (toX - fromX);
                    var t = toY - a * toX;

                    var y = a * mouseX + t;
                    var x;

                    if (toX !== fromX) {
                        x = (mouseY - t) / a;
                    }
                    else {
                        x = toX;
                    }

                    var midFromX = fromX + (toX - fromX) / 3;
                    var midToX = toX - (toX - fromX) / 3;
                    var midFromY = fromY + (toY - fromY) / 3;
                    var midToY = toY - (toY - fromY) / 3;

                    var yDelta = Math.abs(y - mouseY);
                    var xDelta = Math.abs(x - mouseX);

                    if (yDelta < 5 || xDelta < 5) {

                        hovered = true;

                        if (canvas.hoveredEdge !== i) {
                            canvas.hoveredEdge = i;
                            updateNeeded = true;
                        }

                        if (inRect(fromX, midFromX, fromY, midFromY)) { // left
                            hoveredEdgeArea = _left;
                            edge.portOut.resetColor();

                            // die damit die hoverColor bei mehreren inPorts resetted wird, falls man schnell mit der Maus ueber die Kanten faehrt
                            for(var k = 0; k < edge.portIn.parent.inPorts.length; k++){
                                if(edge.portIn !== edge.portIn.parent.inPorts[k]){
                                    edge.portIn.parent.inPorts[k].resetColor()
                                }
                            }

                            edge.portIn.viewPort.color = canvas.hoverColor;
                        }
                        else if (inRect(midToX, toX, midToY, toY)) { // right
                            hoveredEdgeArea = _right;
                            edge.portOut.viewPort.color = canvas.hoverColor;
                            edge.portIn.resetColor();
                        }
                        else { // center
                            hoveredEdgeArea = _center;
                            edge.portOut.resetColor();
                            for(var l = 0; l < edge.portIn.parent.inPorts.length; l++){
                                edge.portIn.parent.inPorts[l].resetColor()
                            }
                        }

                        break;
                    }
                }

                if (!hovered && canvas.hoveredEdge >= 0) {
                    canvas.edges[canvas.hoveredEdge].portOut.resetColor();
                    canvas.edges[canvas.hoveredEdge].portIn.resetColor();
                    canvas.hoveredEdge = -1;
                    updateNeeded = true;
                }

                if (updateNeeded) {
                    canvas.update();
                    canvas.requestPaint();
                }
            }

            else { // pressed

                if (hoveredFromPort != null) {

                    toPortHovered = false;
                    var fromNode = hoveredFromPort.parent;
                    var fromPort = hoveredFromPort;

                    canvas.edgeFromX = fromPort.viewPort.absCenterX;
                    canvas.edgeFromY = fromPort.viewPort.absCenterY;
                    canvas.edgeToX = mouseX;
                    canvas.edgeToY = mouseY;


                    loopAllNodes : for (i = 0; i < canvas.nodes.length; i++) {
                        var toNode = canvas.nodes[i];
                        if (toNode === fromNode) {
                            continue;
                        }

                        var toPort;

                        if (fromPort === fromNode.portOut) {// Kante von links nach rechts

                            for (var n=0; n<toNode.inPorts.length; n++) {
                                toPort = toNode.inPorts[n];
                                if(drawEdge(toPort, toNode)) {
                                    break loopAllNodes;
                                }
                            }
                        }
                        else {
                            toPort = toNode.portOut;
                            if(drawEdge(toPort, toNode)) {
                                break;
                            }
                        }
                    }
                    canvas.requestPaint();
                    canvas.update();
                    if (!toPortHovered && hoveredToPort != null) {
                        hoveredToPort.resetColor();
                        hoveredToPort = null;
                    }
                    canvas.update();
                    canvas.requestPaint();
                }
            }
        }


        function retrieveEdge(toPort) {
            var port = hoveredFromPort; // der port, von dem man ausgegangen ist
            var node = port.parent;
            var hovNode = toPort.parent; //Knoten, von dem ausgegangen wird
            var inNode;
            var outNode;
            var portIn;
            var portOut;

            if(port === node.portOut) { //von links nach rechts gezogen
                inNode = hovNode;
                outNode = node;
                for(var i=0; i<inNode.inPorts.length; i++) {
                    if(hoveredToPort === inNode.inPorts[i]) {
                        portIn = inNode.inPorts[i];
                        break;
                    }
                }
            }
            else {
                inNode = node;
                outNode = hovNode;
                portIn = port;
            }
            portOut = outNode.portOut;
            return { "portIn": portIn, "portOut": portOut };
        }

        function inRect(fromX, toX, fromY, toY) {
            if (mouseX < Math.min(fromX, toX) || mouseY < Math.min(fromY, toY) || mouseX > Math.max(fromX, toX) || mouseY > Math.max(fromY, toY)) {
                return false;
            }
            else {
                return true;
            }
        }

        function inRect2(x, y, height, width) {
            return inRect(x, x + width, y, y + height);
        }
    }



    function removeNode(node) {
        if(node.isInPipeline){
            statusBar.printMessage("You can't remove a Node in progress")
            return
        }
        if(node.isQueued){
            statusBar.printMessage("You can't remove a queued Node")
            return
        }

        var edgeFound = false;
        for (var i = 0; i < edges.length; i++) {
            var edge = edges[i];

            if (edge.portOut.parent === node) {
                removeEdge(i);
                updatePortColor(edge.portIn);
                i--;
                edgeFound = true;
            }
            else if (edge.portIn.parent === node) {
                removeEdge(i);
                updatePortColor(edge.portOut);
                i--;
                edgeFound = true;
            }
        }

        for (i = 0; i < nodes.length; i++) {
            var n = nodes[i];

            if (n === node) {
                nodes.splice(i, 1);
                break;
            }
        }
        if(node.isShown){
            viewArea.clearShown(node)
            menuManager.hasImage = false
        }

        node.destroy();

        if (edgeFound) {
            update();
            requestPaint();
        }
        menuManager.updateConfig(); // Nodes array wurde verändert
        menuManager.updateSelectedNodes();

    }

    function isEdgeAllowed(toPort) {

        var curEdge = mouseArea.retrieveEdge(toPort);

        if(curEdge.portIn !== toPort && curEdge.portIn !== undefined) {
            toPort = curEdge.portIn;
        }
        else {
        }

        if(toPort.isConnected === true ) {
            return false;
        }
        else {
            // pruefung ob die Kante einen Zyklus erstellen würde
            var val = curEdge.portOut.parent.model.hasGraphCircle(toPort.parent.model)
            return !val;
        }
    }

    function addEdge(edge) {

        edge.portIn.parent.model.addInNode(edge.portOut.parent.model);
        edge.portOut.parent.model.addOutNode(edge.portIn.parent.model);

        edge.portIn.isConnected = true;

        edges.push(edge);
        menuManager.configChanged(); // neue Kante erzeugt -> Config hat sich verändert
    }

    function removeEdge(index) {
        var tmp = edges[index]
        if(tmp.portIn.parent.isInPipeline){
            statusBar.printMessage("You can't remove this Edge while the Node is still in progress")
            return null
        }

        var edge = edges.splice(index, 1)[0];

        edge.portIn.isConnected = false;
        edge.portIn.parent.model.removeInNode(edge.portOut.parent.model);
//        edge.portOut.parent.model.removeOutNode(edge.portIn.model);
//        edge.portIn.parent.model.clearInNodes();
        edge.portIn.parent.model.cleanCache()
        edge.portOut.parent.model.clearOutNodes();
        menuManager.configChanged(); // wenn Kante gelöscht wird -> Config hat sich verändert

        return edge;
    }

    // needed after removing an edge
    function updatePortColor(port) {
        for (var i = 0; i < edges.length; i++) {
            var edge = edges[i];
            if (port === edge.portOut) {
                return;
            }
            if (port === edge.portIn) {
                return;
            }
        }
        port.resetDefaultColor();
        port.viewPort.color = port.defaultColor;
    }

    function drawEdge (toPort, toNode) {
        if (toPort.isHovered && isEdgeAllowed(toPort)) {

            toPort.viewPort.color = canvas.edgeColor;
            hoveredToPort = toPort;
            toPortHovered = true;

            canvas.edgeToX = toPort.viewPort.absCenterX;
            canvas.edgeToY = toPort.viewPort.absCenterY;

            // damit die Farbe bei mehreren inPorts, beim wechseln von einem inPorts zum anderen resetted wird
            for(var i = 0; i < toNode.inPorts.length; i++){
                if(toNode.inPorts[i] !== toPort){
                    if(!toNode.inPorts[i].isConnected){
                        toNode.inPorts[i].resetColor()
                    }
                }
            }
            canvas.update();
            canvas.requestPaint();

            return true;
        }
    }

    function isCornerInRectangle(x,y) {
        var rectTopLeft = { x : null, y : null};
        var rectBottomRight = { x : null, y : null};

        if (lastx < mx && lasty < my) { //von links oben nach rechts unten gezogen
            rectTopLeft.x = lastx;
            rectTopLeft.y = lasty;
            rectBottomRight.x = mx;
            rectBottomRight.y = my;
        }
        else if (lastx > mx && lasty > my) {
            rectTopLeft.x = mx;
            rectTopLeft.y = my;
            rectBottomRight.x = lastx;
            rectBottomRight.y = lasty;
        }
        else if (lastx < mx && lasty > my) {
            rectTopLeft.x = lastx;
            rectTopLeft.y = my;
            rectBottomRight.x = mx;
            rectBottomRight.y = lasty;
        }
        else if (lastx > mx && lasty < my) {
            rectTopLeft.x = mx;
            rectTopLeft.y = lasty;
            rectBottomRight.x = lastx;
            rectBottomRight.y = my;
        }
        if(x > rectTopLeft.x && y > rectTopLeft.y && x < rectBottomRight.x && y < rectBottomRight.y) {
            return true;
        }
        else
            return false;
    }
    function markSelectedNodes() {

        for (var i = 0; i<nodes.length; i++) {
            var node = canvas.nodes[i];

            var nodeTopLeft = {x : node.x, y: node.y};
            var nodeBottomLeft = {x : node.x, y: node.y+node.height};
            var nodeTopRight = {x : node.x+node.width, y: node.y};
            var nodeBottomRight = {x : node.x+node.width, y: node.y+node.height};

            if(isCornerInRectangle(nodeTopLeft.x, nodeTopLeft.y)) {
                if(isCornerInRectangle(nodeBottomLeft.x, nodeBottomLeft.y)) {
                    if(isCornerInRectangle(nodeTopRight.x, nodeTopRight.y)) {
                        if(isCornerInRectangle(nodeBottomRight.x, nodeBottomRight.y)) {
                            node.rect.state = 'select'
                            node.isSelected = true;
                            menuManager.updateSelectedNodes();
                        }
                    }
                }
            }
        }
    }
    function resetSelectedNodes() {
        for(var i=0; i<nodes.length; i++) {
            var node = nodes[i];
            if(node.isSelected === true && hoveredToPort === null) {
                node.resetToDefault();
                node.isSelected = false;
                menuManager.updateSelectedNodes();
            }
        }
    }
    function swap (a, x, y) {
        if (a.length === 1) return a;
        a.splice(y, 1, a.splice(x, 1, a[y])[0]);
        return a;
    }

    function getShownImageNode() {
        for(var i = 0; i < nodes.length; i++){
            var node = nodes[i]
            if(node.isImageShown)
                return node
        }
        return null
    }

    function deselectAllNodes(){
        for(var i = 0; i < nodes.length; i++){
            var node = nodes[i]
            node.deselect()
        }
    }

    // damit die nodes nicht verdeckt werden, falls man in den Settings Favorites bzw StatusBar ein und ausblendet
    function moveNodes(value, length){
        var dist = value ? -length : length
        for(var i = 0; i < nodes.length; i++){
            nodes[i].y += dist
            if(nodes[i].y < 0)
                nodes[i].y = 0
            var sH = 0
            if(length === 0) // +1 wegen handleDelegate der SplitView
                sH = value ? statusBar.height + 1 : 0
            if(nodes[i].y + nodes[i].height > canvas.height - sH)
                nodes[i].y = canvas.height - sH - nodes[i].height
        }
    }

    function setPipelineFlag(node, value){
        var pipeline = [node]
        while(pipeline.length > 0){
            var currNode = pipeline.pop()

            currNode.isInPipeline = value

            for(var i = 0; i < currNode.inPorts.length; i++){
                if(currNode.inPorts[i].isConnected){
                    var edge = null

                    for(var j = 0; j < edges.length; j++){
                        if(edges[j].portIn.parent === currNode){
                            var notInArray = true
                            // check if node is already in the Pipeline Array
                            for(var k = 0; k < pipeline.length; k++){
                                if(edges[j].portOut.parent === pipeline[k]){
                                    notInArray = false
                                }
                            }
                            if(notInArray){
                                edge = edges[j]
                                break;
                            }
                        }
                    }
                    if(edge !== null){
                        pipeline.push(edge.portOut.parent)
                    }
                }
            }
        }
    }

    function getNodeCounter(nodeName){
        var num = 0
        nodes.forEach(function(i){
            if(nodeName === i.objectName){
                if(num < i.number){
                    num = i.number
                }
            }
        })
        num++
        return num


//        var nbrs = []
//        for(var i = 0; i < nodes.length; i++){
//            if(nodes[i].objectName === node.objectName){
//                nbrs.push(nodes[i].number)
//            }
//        }
//        // sort numbers in ascending order
//        nbrs.sort(function compareNumbers(a, b) {
//            return a - b;
//        })

//        // smallest number
//        var num = 1
//        nbrs.forEach(function(number){
//            if(num === number){
//                num++
//            } else {
//                // fill gap
//                return
//            }
//        })
//        node.number = num
    }

}
//}
//}


