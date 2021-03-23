pragma Singleton

import QtQuick 2.0
import QtCharts 2.15

// Theme Singleton: Globale Konstanten fuer alle Objekte
// Farben, Font usw sollen nur hier geaendert werden

QtObject{
    property bool darkMode: true
    property bool colorfulMode: false
    property bool accentEnabled: true

    readonly property color mainColor: darkMode ?  "#303030" :  "white"
    readonly property color accentColor:  "#4182AF"

    // Einheitliche font in der ganzen Oberfläche
    readonly property var font: QtObject {
        readonly property string family: "Verdana"
        readonly property int pointSize: 8
    }

    // contentDelegate beschreibt die Farbe aller Texte und Buttons
    readonly property var contentDelegate: QtObject {

        readonly property var color: QtObject {
            readonly property var background: QtObject {
                readonly property color normal: darkMode ?  "#292929" :  "white"
                readonly property color hover: darkMode ?  "#383838" :  "#F3F3F3"
                readonly property color press: darkMode ?  "#4D4D4D" :  "#EEEEEE"
                readonly property color pressAndHold:  Theme.accentColor
                readonly property color disabled: darkMode ? "#383838" : "#F3F3F3"
            }

            readonly property var text: QtObject {
                readonly property color normal: darkMode ?  "#919191" :  "#A1A1A1"
                readonly property color hover: darkMode ?  "#A8A8A8" :  "#949494"
                readonly property color press: darkMode ?  "#C2C2C2" :  "#828282"
                readonly property color pressAndHold: "white"
                readonly property color disabled: darkMode ? "#919191" : "#A1A1A1"
            }
        }
        readonly property int height: 40
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
                readonly property color normal: darkMode ? "#40556B" : "#4182AF"
                readonly property color border: Qt.darker(node.color.background.normal)
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
                readonly property color normal: darkMode ?  "#4A4A4A" :  "gainsboro"
            }
            readonly property var stroke: QtObject {
                readonly property color normal: darkMode ?  "lightgray" :  "darkgray"
            }
            readonly property var edge: QtObject {
                readonly property color normal: "#B80012"
                readonly property color hover: Theme.node.color.border.hover
            }
        }
    }

    // ViewArea Color
    readonly property var viewArea: QtObject {
        readonly property var defaultColor: QtObject {
            readonly property color normal: Theme.accentColor
            readonly property color shown: "#406BC7"

        }
        readonly property var colors: [
            "dodgerblue",
            "crimson",
            "slateblue",
            "greenyellow",
            "springgreen",
            "gold",
            "coral",
            "deepskyblue",
            "deeppink",
            "olivedrab"
        ]
    }
}

