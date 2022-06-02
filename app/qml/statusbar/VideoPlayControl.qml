import QtQuick 2.15

import Theme 1.0
import "../components/"

GIconButton {
    id: playButton

    property var task: null

    action: task ? task.isPlayState ? task.pauseAction : task.playAction : undefined
    toolTip.text: action.text
}
