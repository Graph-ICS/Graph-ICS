import QtQuick 2.0

Item {

    // erstellt auf der Basis von ItkCannyEdgeDetectionFilter.qml eine NodeView mit optional Attributen, falls diese im Backend registriert wurden (siehe: ItkCannyEdgeDetectionFilter Constructor)
    function createNodeQmlString(compName){
//        print(compName)
        var imports = 'import QtQuick 2.15;
            import "nodes/components/";
            import Model.' + compName + ' 1.0;
            '

        var nodeModel = compName + '_Model {
            id: model;
        }'

        var connection = 'Connections{
            target: model

            function onCached(value){
                isCached = value;
            }
            function onAttributeValuesUpdated() {
                updateAttributeValues()
            }
        }
        '
        var savePart = 'function saveNode(name) {
            var obj
            obj = { x: node.x, y: node.y, objectName : objectName'
        var loadPart = 'function loadNode(nodeData) {
            for(var i = 0; i < attributes.length; i++){
                model.setAttributeValue(attributes[i].objectName, nodeData[attributes[i].objectName])
            }
            updateAttributeValues()
        }
        '

        // model Object muss erstellt werden um getAttributeNames der Node-Klasse aufzurufen
        var model = Qt.createQmlObject(imports + nodeModel, root)
        var attributeNames = model.getAttributeNames()
        var inPortsPart = buildInPortsPart(model.getInPortCount())

        // attributes array
        var attribute = ''
        // NodeAttributes
        var nodeAttributes = ''
        for(var i = 0; i < attributeNames.length; i++){
            var topAnchor
            if(i === 0){
                topAnchor = 'title'
                attribute = 'attributes: ['
                savePart += ',
                '
            } else {
                topAnchor = attributeNames[i-1]
            }

            attribute += attributeNames[i]

            savePart += attributeNames[i] + ': model.getAttributeValue( '+ attributeNames[i] + '.objectName)'
//            loadPart += 'model.setAttributeValue('+ attributeNames[i] + '.objectName, nodeData.'+ attributeNames[i] + ');
//            '

            // solange nicht letztes Element in attributeNames
            if(i !== attributeNames.length -1){
                attribute += ', '
                savePart += ',
                '
            } else {
                // letztes Element in attributeNames
                // attributes array finished
                attribute += '];'
            }
            var attributeType = model.getAttributeType(attributeNames[i])
            var constraint = ""
            if(attributeType === "Path"){
                constraint = 'nameFilters: [' + model.getAttributeConstraint(attributeNames[i], "nameFilter") + ']'
            }

            nodeAttributes += 'Node' + attributeType + 'Attribute {
                id: '+ attributeNames[i] +'
                '+ constraint +'
                objectName: "'+ attributeNames[i] + '"
                anchors.top: '+ topAnchor +'.bottom
            }
            '
        }

        var basePart = 'GNode {
            id: node
            ' + inPortsPart + '
            objectName: model.getNodeName()
            property alias model: model
            ' + nodeModel + '
            title: title
            NodeTitle {
                id: title
            }'

        //save function finished
        savePart += '}
            return obj
        }'
        //load function finished
//        loadPart += 'updateAttributeValues() }'

        var str = imports +
                    basePart +
                    attribute +
                    nodeAttributes +
                    connection +
                    savePart +
                    loadPart  + '}'

        return str
    }

    function buildInPortsPart(count){
        var inPortsPart = ""
        var arrayPart = ""
        for(var i = 1; i <= count; i++){
            var str = 'Port {
                id: portIn' + i + '
                x: -width + viewPort.width / 2
                y: parent.height / '+ (count + 1) + ' - height / 2 + (' + (i - 1) + ' * ' + '(parent.height / '+ (count + 1) + '))
                viewPort.x : width - viewPort.width
            }
            '
            inPortsPart += str

            str = 'inPorts.push(portIn' + i + '); '

            arrayPart += str
        }
        var result = inPortsPart +
                'Component.onCompleted: {
                    '+ arrayPart +'
                }'

        return result
    }
}
