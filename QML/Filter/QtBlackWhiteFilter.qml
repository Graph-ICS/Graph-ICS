import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

import ".."
import Model.QtBlackWhiteFilter 1.0

GFilter {
    id: gNode

    QtBlackWhiteFilter {
        id: model
    }

    property alias model: model

    Label {
        x: 5
        y: 10
        color: "#ffffff"
        font.bold: true
        text: "BlackWhite"
    }
}
