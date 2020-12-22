import QtQuick 2.15
import QtQuick.Controls 2.15

import "components/"

// Add ListElements here to Display a Warning after the Node was dropped

Item {
    property bool disabled: false

    GWarningDialog {
        id: warning
    }

    function showWarning(node){
        if(!disabled){
            var txt = node.model.getWarningMessage()
            if(txt !== "") {
//                warning.text = txt
//                warning.showNormal()
                statusBar.printMessage(node.objectName + ": " + txt)
            }
        }
    }

}
