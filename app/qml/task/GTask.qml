import QtQuick 2.15
import QtQuick.Controls 2.15

import Theme 1.0

Item {
    id: task
    property var model

    property string name: ""
    property string type: ""
    property int portType: -1

    property bool isCancelRequested: false
    property var handleCancelNotAllowed: function (messageCode) {}

    signal cancelled
    signal cancelHandled(bool isHandled)

    property Action cancelAction: Action {
        text: qsTr("Cancel Task")
        icon.source: Theme.icon.trash
        onTriggered: {
            isCancelRequested = true
            if (model.isCancelAllowed()) {
                model.cancel()
            } else {
                let messageCode = model.getCancelNotAllowedReason()
                handleCancelNotAllowed(messageCode)
            }
        }
        enabled: !isCancelRequested
    }

    onModelChanged: {
        isCancelRequested = false
    }

    function isCancelled() {
        return model.isCancelled()
    }

    function forceCancel() {
        model.cancel()
    }

    Connections {
        target: model ? model : null
        function onCancelled() {
            cancelled()
        }
    }
}
