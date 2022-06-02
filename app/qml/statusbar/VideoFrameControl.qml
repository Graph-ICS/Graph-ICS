import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15

import Theme 1.0
import "../components/"
import "../task"

GSlider {
    id: frameSlider

    property var task: null

    snapMode: Slider.NoSnap

    from: 0
    to: task ? task.amountOfFrames === 0 ? 0 : task.amountOfFrames - 1 : 0
    value: task ? task.frameId : 0

    onValueChanged: {
        if (pressed) {
            task.setFrameId(value)
        }
    }

    onPressedChanged: {
        if (pressed) {
            task.startSliding(value)
        } else {
            task.endSliding(value)
        }
    }

    toolTip.text: qsTr("Select Frame " + value)

    enabled: task ? !task.isSavingVideo & to != 0 : false
}
