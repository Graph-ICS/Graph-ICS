pragma Singleton

import QtQuick 2.0

// Theme Singleton: Globale Konstanten fuer alle Objekte
// Farben, Font usw sollen nur hier geaendert werden

QtObject{
    property bool darkMode: true
    property bool colorfulMode: false
    property bool accentEnabled: true

    readonly property color mainColor: darkMode ? colorfulMode ? "" : "#303030" : colorfulMode ? "" : "white"
    readonly property color accentColor: colorfulMode ? "" : "#4182AF"

    // Einheitliche font in der ganzen Oberfläche
    readonly property var font: QtObject {
        readonly property string family: "Verdana"
        readonly property int pointSize: 8
    }

    // contentDelegate beschreibt die Farbe aller Texte und Buttons
    readonly property var contentDelegate: QtObject {

        readonly property var color: QtObject {
            readonly property var background: QtObject {
                readonly property color normal: darkMode ? colorfulMode ? "" : "#292929" : colorfulMode ? "" : "white"
                readonly property color hover: darkMode ? colorfulMode ? "" : "#383838" : colorfulMode ? "" : "#F3F3F3"
                readonly property color press: darkMode ? colorfulMode ? "" : "#4D4D4D" : colorfulMode ? "" : "#EEEEEE"
                readonly property color pressAndHold: colorfulMode ? "" : Theme.accentColor
            }

            readonly property var text: QtObject {
                readonly property color normal: darkMode ? colorfulMode ? "" : "#575757" : colorfulMode ? "" : "#A1A1A1"
                readonly property color hover: darkMode ? colorfulMode ? "" : "#757575" : colorfulMode ? "" : "#949494"
                readonly property color press: darkMode ? colorfulMode ? "" : "#8C8C8C" : colorfulMode ? "" : "#828282"
                readonly property color pressAndHold: "white"
            }
        }
    }

    readonly property var textField: QtObject {
        readonly property var color: QtObject {
            readonly property var background: QtObject {
                readonly property color normal: "gainsboro"
                readonly property color disable: "silver"
            }
            readonly property var text: QtObject {
                readonly property color normal: "dimgray"
                // hier bezieht sich select auf den markierten Text (selected)
                readonly property color select: "white"
            }
            readonly property var border: QtObject {
                readonly property color normal: "white"
            }
        }
    }

    // Node Farben
    readonly property var node: QtObject {
        readonly property var color: QtObject {

            readonly property var background: QtObject {
                readonly property color normal: colorfulMode ? "#0D3A94" : Theme.accentColor
                // shown: die Farbe des Nodes falls das dementsprechende
                // Image gerade in der View angezeigt wird
                readonly property color shown: /*"darkcyan"*/ colorfulMode ? "#69183E" : "teal"
            }

            readonly property var port: QtObject {
                readonly property color normal: "white"
            }

            readonly property var text: QtObject {
                readonly property color normal: "white"
            }

            readonly property var border: QtObject {
                // border.normal wird in der NodeBase bestimmt, (Qt.darker(node.color.background))
                // da die Nodefarbe nicht konstant ist
                readonly property color select: "#FF8A00"
                readonly property color hover: "#FFB201"
            }
        }
    }

    // Canvas Farben
    readonly property var canvas: QtObject {
        readonly property var color: QtObject {
            readonly property var background: QtObject {
                readonly property color normal: darkMode ? colorfulMode ? "" : "#4A4A4A" :colorfulMode ? "" :  "gainsboro"
            }
            readonly property var stroke: QtObject {
                readonly property color normal: darkMode ? colorfulMode ? "" : "lightgray" : colorfulMode ? "" : "darkgray"
            }
            readonly property var edge: QtObject {
                readonly property color normal: "#B80012"
                readonly property color hover: Theme.node.color.border.hover
            }
        }
    }
}

