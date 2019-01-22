import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2

import Model.Image 1.0


GNode {

    height: 70
    width: 110
    objectName: "Image"
    id: image

    Image_Model {
        id: model
    }

    property alias model: model

    Label {
        x: 5
        y: 10
        width: 34
        height: 14
        color: "#ffffff"
        font.bold: true
        text: "Image"
    }
    Button {
        x: 71
        y: 28
        width: 35
        height: 35
        background: Rectangle {
            width: parent.width
            height: parent.height
            color: "transparent"
        }
        Image{
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            source: "../doc/icon.png"
        }
        onClicked: {
            imageDialog.open();
        }
    }

    TextField {
        x: 5
        y: 35
        width: 65
        height: 24
        font.pixelSize: 12
        selectByMouse: true
        leftPadding: 6
        rightPadding: 6
        topPadding: 0
        bottomPadding: 0

        placeholderText: qsTr("Pfad")
        text: model.path

        onTextChanged: {
            model.path = text;
        }
    }
    FileDialog {
        id: imageDialog
        nameFilters: [ "Image files (*.png *.jpg)", "All files (*)" ]
        selectedNameFilter: "Image files (*)"
        onAccepted: {
            var buf = String(imageDialog.fileUrl);
            model.path = buf.substring(8, buf.length); // Präfix file/// anschneiden
            gImageProvider.img = model.getResult();
            root.splitView.imageView.reload();
        }
    }
    function saveNode() {
        var obj;
        obj = { x: x, y: y,
        objectName : objectName,
        path: model.path};
        return obj;
    }
    function loadNode(nodeData) {
        image.model.path = nodeData.path;
    }
}

