import QtQuick 2.15

import Theme 1.0

Item {
    id: attribute

    property var node

    property var model
    property string name

    readonly property var value: model ? model.value : null
    readonly property var defaultValue: model ? model.getDefaultValue() : null
    readonly property string displayedName: model ? model.getDisplayedName(
                                                        ) : ""
    readonly property bool isLocked: model ? model.isLocked : false

    readonly property var defaultFont: Theme.font.caption

    property alias nameText: nameText

    height: Theme.baseHeight

    Text {
        id: nameText

        text: displayedName

        leftPadding: Theme.largeSpacing
        rightPadding: Theme.largeSpacing

        font: defaultFont
        color: Theme.onprimary
    }

    function setValue(value) {
        model.value = value
    }

    function restoreDefault() {
        model.value = defaultValue
    }
}
