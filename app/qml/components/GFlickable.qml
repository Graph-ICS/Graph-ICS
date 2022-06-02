import QtQuick 2.15
import QtQuick.Controls 2.15

Flickable {
    id: gflickable

    property bool scrollHorizontal: false

    interactive: false
    clip: true

    boundsBehavior: Flickable.DragAndOvershootBounds

    function scrollContent(wheel) {
        if (scrollHorizontal) {
            if (gflickable.atXEnd && wheel.angleDelta.y < 0) {
                return
            }
            if (gflickable.atXBeginning && wheel.angleDelta.y > 0) {
                return
            }
            gflickable.flick(wheel.angleDelta.y * 7, 0)
        } else {
            if (gflickable.atYEnd && wheel.angleDelta.y < 0) {
                return
            }
            if (gflickable.atYBeginning && wheel.angleDelta.y > 0) {
                return
            }
            gflickable.flick(0, wheel.angleDelta.y * 7)
        }
    }
}
