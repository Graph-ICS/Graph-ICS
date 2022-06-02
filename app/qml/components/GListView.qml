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
    property alias listView: list
    property alias scrollBar: scrollbar

    anchors.fill: parent

    MouseArea {
        anchors.fill: list
        onWheel: {
            if (horizontal) {
                if (list.atXEnd && wheel.angleDelta.y < 0) {
                    return
                }
                if (list.atXBeginning && wheel.angleDelta.y > 0) {
                    return
                }
                list.flick(wheel.angleDelta.y * 6, 0)
            } else {
                if (list.atYEnd && wheel.angleDelta.y < 0) {
                    return
                }
                if (list.atYBeginning && wheel.angleDelta.y > 0) {
                    return
                }
                list.flick(0, wheel.angleDelta.y * 6)
            }
        }
    }
    GScrollBar {
        id: scrollbar
        anchors {
            left: list.left
            right: horizontal ? list.right : undefined
            top: list.top
            bottom: horizontal ? undefined : list.bottom
        }
        visible: horizontal ? list.width < list.contentWidth : list.height < list.contentHeight
        height: 10
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
        boundsBehavior: Flickable.DragAndOvershootBounds
        orientation: horizontal ? ListView.Horizontal : ListView.Vertical
        ScrollBar.vertical: horizontal ? null : scrollbar
        ScrollBar.horizontal: horizontal ? scrollbar : null
    }
}
