import QtQuick 2.0

Item {
    property string windowTitle: defaultWindowTitle;
    property string defaultWindowTitle : "New Config";
    property string filePath: ""

    property bool hasConfig: false;
    property bool hasImage: false;
    property bool hasConfigChanged: false;
    property bool hasSelectedNodes: false
    property bool hasNodesToPaste: false
    property string changedSymbol: ""
    property bool hasOneNode: false

    function updateConfig() {
        if(canvas.nodes.length > 0) {
            hasConfig = true;
        }
        else {
            hasConfig = false;
        }
        configChanged();
    }
    function updateSelectedNodes() {
        var counter = 0;
        for (var i=0; i<canvas.nodes.length; i++) {
            var node = canvas.nodes[i];
            if(node.isSelected === true) {
                counter++;
            }
        }
        if(counter === 0) {
            hasSelectedNodes = false;
            hasOneNode = false;
        }
        if(counter > 0) {
            hasSelectedNodes = true;
            hasOneNode = false;
            if(counter === 1) {
                hasOneNode = true;
            }
        }
    }
    function updateView() {
        var counter = 0;
        for (var i=0; i<canvas.nodes.length; i++) {
            var node = canvas.nodes[i];
            if(node.isSelected === true) {
                counter++;
            }
        }
        if( counter === 1) {
            hasOneNode = true;
        }
        else {
            hasOneNode = false;
        }
    }

    function updatePaste () {
        if(menuBar.selectedNodes.length > 0) {
            hasNodesToPaste = true;
        }
        else {
            hasNodesToPaste = false;
        }
    }

    function isSaveConfigAllowed() {
        if(hasConfig && hasConfigChanged)
        {
            return true;
        }
        else {
            return false;
        }
    }
    function isSaveConfigAsAllowed() {
        if(hasConfig) {
            return true;
        }
        else {
            return false;
        }
    }
    function isSaveImageAsAllowed() {
        return hasImage
    }
    function isClearImageAllowed() {
        return hasImage
    }
    function isEditAllowed() {
        if(hasSelectedNodes === true) {
            return true;
        }
        else {
            return false;
        }
    }
    function isPasteAllowed() {
        if(hasNodesToPaste === true) {
            return true;
        }
        else {
            return false;
        }
    }
    function isNewConfigDialogAllowed() {
        if (changedSymbol === "") {
            return false;
        }
        else {
            return true;
        }
    }
    function isViewAllowed () {
        if (hasOneNode) {
            return true
        }
        else {
            return false
        }
    }

    function isExportVideoAllowed() {
        if(hasImage){
            var node = canvas.getShownImageNode()
            if(node !== null){
                if(node.model.getInputNodeName() === "Video") {
                    if(node.isCached){
                        return true
                    }
                }
            }
        }
        return false
    }

    //ComoBoxItem
    function isAddToFavoritesAllowed(filterName) {
        for (var i=0; i<toolBar.toolbarItems.length; i++) {
            var item = toolBar.toolbarItems[i];
            if(filterName === item.label.text) {
                return false;
            }
        }
        return true;
    }
    function configChanged() {
        hasConfigChanged = true;
        changedSymbol = "*";
        if(!hasConfig) {
            changedSymbol = null;
        }
    }
    function configResetted() {
        changedSymbol = null;
        hasConfigChanged = false;
    }
    function prepareNewConfig() {
        windowTitle = "New Config";
        changedSymbol = null;
        filePath = null;
        hasConfig = false;
        hasSelectedNodes = false;
    }
    function retrieveSelectedNode() {
        var selectedNode;
        for (var i=0; i<canvas.nodes.length; i++) {
            var node = canvas.nodes[i];
            if(node.isSelected === true) {
                selectedNode = node;
                return selectedNode;
            }
        }
    }
}
