import QtQuick 2.15

import "../../components"

import Theme 1.0
import Global 1.0

GAttribute {
    id: switchAttribute

    width: gswitch.width + nameText.width

    nameText.anchors.left: gswitch.right
    nameText.anchors.verticalCenter: gswitch.verticalCenter

    GSwitch {
        id: gswitch
        enabled: !isLocked

        height: parent.height

        checked: value
        onCheckedChanged: {
            setValue(checked)
        }

        switchColor: Theme.onprimary
        switchColorChecked: Theme.primaryDark
    }

    onValueChanged: {
        gswitch.checked = value
    }
}
