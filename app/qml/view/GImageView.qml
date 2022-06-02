import QtQuick 2.15
import QtQuick.Controls 2.15

import Theme 1.0
import Model.ImageView 1.0

import "../"
import "../components/"
import "../menu/"

GView {
    id: imageView

    model: ImageViewModel {
        id: model
        Component.onCompleted: {
            image.imageProviderPath = String(model.getImageProviderPath())
        }
    }

    Image {
        id: image

        property string imageProviderPath: ""

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        width: parent.width
        height: parent.height
        cache: false
        property int counter: 0
        fillMode: Image.PreserveAspectFit

        function reload() {
            counter++
            source = "image://" + imageProviderPath + "/" + counter
            height = parent.height
        }
        function reloadNewImage(path) {
            source = path
        }
    }

    Connections {
        target: model

        function onUpdated() {
            image.reload()
            updated()
        }

        function onCleared() {
            image.source = ""
        }
    }
}
