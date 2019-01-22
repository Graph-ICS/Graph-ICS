import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

import ".."
import Model.ItkSubstract 1.0


GFilter2Ports {
    id: gNode

    ItkSubstract {
        id: model
    }

    property alias model: model

    Label {
        x: 5
        y: 10        
        width: 62
        height: 27
        color: "#ffffff"
        font.bold: true
        text: "Itk Substract"
        wrapMode: Text.WordWrap
    }
}



