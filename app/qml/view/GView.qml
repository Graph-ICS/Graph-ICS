import QtQuick 2.15
import QtQuick.Controls 2.15

import Theme 1.0
import "../"

Item {
    id: view

    property var model
    property list<Action> menuActions
    signal updated

    function clear() {
        if (view.model) {
            view.model.clear()
        }
    }
}
