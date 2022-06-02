pragma Singleton

import QtQuick 2.15
import Qt.labs.settings 1.1

QtObject {

    property string onlineDocsLink: "https://github.com/Graph-ICS/Graph-ICS/blob/main/README.md"

    // ****************
    // Task/Node handling
    signal savingVideo
    signal nodeDisconnectViewFailed(var node)
    property var focusedView: null
    readonly property var focusedTask: focusedView ? focusedView.task : null

    // ****************
    // File handling
    property var imageFilesNameFilters: []
    property var videoFilesNameFilters: []

    // ****************
    // Global functions that appear often and could be replacted in the future
    // Injected in main.qml Component.onCompleted
    property var printUserMessage: function (message) {}

    // ****************
    // App settings
    readonly property Settings windowSettings: Settings {
        category: "Window"
        property var splitViewState
        property var canvasSplitViewState
        property int viewsCount: 2
        property bool searchpanelEnabled: true
        property bool favoritesbarEnabled: true
        property bool statusbarEnabled: true
        property var favoritebarItems: ["Image", "Video", "ItkCannyEdgeDetection", "CvSobelOperator"]
    }
    readonly property Settings behaviorSettings: Settings {
        category: "Behavior"
        property bool searchOnTyping: false
        property bool showFindHelp: true
    }
    readonly property Settings themeSettings: Settings {
        category: "Theme"
        property bool darkModeEnabled: true
        property bool accentEnabled: true
    }
}
