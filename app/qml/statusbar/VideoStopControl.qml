import QtQuick 2.15

import Theme 1.0
import "../components/"
import "../task"

GIconButton {
    id: stopButton

    property var task: null

    action: task ? task.isSavingVideo ? task.cancelSaveVideoAction : task.stopAction : undefined
    toolTip.text: action.text
}
