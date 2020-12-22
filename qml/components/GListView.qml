import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls 2.2
import QtQml.Models 2.15

Item {
    id: graphics_ListView

    property bool horizontal: false
    property alias model: delegate.model
    property alias delegate: delegate.delegate
    property alias gDelegateModel: delegate

    anchors.fill: parent

    MouseArea{
        anchors.fill: list
        onWheel: {
            if(!horizontal)
                list.flick(0, wheel.angleDelta.y * 4)
            else
                list.flick(wheel.angleDelta.y * 4, 0)
        }
    }

    ScrollBar {
        id: scrollbar
        anchors {
            left: list.left
            right: horizontal ? list.right : undefined
            top: list.top
            bottom: horizontal ? undefined : list.bottom
        }
        height: 7
        width: 10
    }

    DelegateModel {
        id: delegate

    }

    ListView {
        id: list
        model: delegate
        anchors.fill: parent
        spacing: 0
        cacheBuffer: 100
        interactive: false
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        orientation: horizontal ? ListView.Horizontal : ListView.Vertical
        ScrollBar.vertical: horizontal ? null : scrollbar
        ScrollBar.horizontal: horizontal ? scrollbar : null

    }
}
