import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import Theme 1.0

ComboBox {
    id: control

    property color itemTextColor: Theme.onsurface
    property color indicatorColor: Theme.onsurface
    property color backgroundColor: Theme.surface

    property bool buttonVisible: false
    property string buttonIcon: ""
    property string buttonToolTipText: ""

    property var defaultFont: Theme.font.body2

    signal buttonClicked(int index)

    textRole: "name"
    model: ListModel {}

    leftPadding: 12

    opacity: enabled ? Theme.opacity.normal : Theme.opacity.disabled

    delegate: ItemDelegate {
        property bool isEnabled: model.enabled === undefined ? true : model.enabled
        enabled: isEnabled

        width: control.width
        height: Theme.smallHeight
        opacity: enabled ? Theme.opacity.normal : Theme.opacity.disabled

        contentItem: Item {
            anchors.fill: parent
            Text {
                text: model.name

                leftPadding: control.leftPadding
                anchors.verticalCenter: parent.verticalCenter

                color: itemTextColor
                font: defaultFont

                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
            GIconButton {
                id: iconButton
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: control.leftPadding

                height: parent.height
                width: height

                transparent: true

                toolTip.text: buttonToolTipText
                icon.source: buttonIcon

                visible: model.buttonVisible
                         !== undefined ? model.buttonVisible : control.buttonVisible
                onClicked: {
                    buttonClicked(index)
                }
            }
        }
        background: Rectangle {
            color: itemTextColor
            opacity: highlightedIndex === index ? Theme.opacity.hover : 0.0
        }
    }

    indicator: Canvas {
        id: canvas
        x: control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        width: 12
        height: 8
        contextType: "2d"

        Connections {
            target: control
            function onPressedChanged() {
                canvas.requestPaint()
            }
        }

        onPaint: {
            if (control.down) {
                context.reset()
                context.moveTo(0, height)
                context.lineTo(width, height)
                context.lineTo(width / 2, 0)
                context.closePath()
                context.fillStyle = indicatorColor
                context.fill()
            } else {
                context.reset()
                context.moveTo(0, 0)
                context.lineTo(width, 0)
                context.lineTo(width / 2, height)
                context.closePath()
                context.fillStyle = indicatorColor
                context.fill()
            }
        }
    }

    contentItem: Text {
        id: text
        leftPadding: 0
        rightPadding: control.indicator.width + control.spacing
        text: control.displayText

        font: defaultFont
        color: itemTextColor

        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: text.implicitWidth + 36
        implicitHeight: 24
        color: backgroundColor
        radius: 1
    }

    PropertyAnimation {
        id: animation
        target: pop
        property bool isOpen: control.down
        property: "height"
        from: isOpen ? pop.contentItem.implicitHeight : 0
        to: isOpen ? 0 : pop.contentItem.implicitHeight
        duration: 100
    }

    onDownChanged: {
        animation.restart()
        canvas.requestPaint()
    }

    popup: Popup {
        id: pop
        y: control.height - 1
        width: control.width
        padding: 0
        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex
            interactive: false
            ScrollIndicator.vertical: ScrollIndicator {}
        }

        background: Rectangle {
            id: bgRect
            color: backgroundColor

            layer.enabled: true
            layer.effect: GDropShadow {
                target: bgRect
            }
        }
    }

    function updatePopupHeight() {
        pop.height = control.model.count * 24
    }
}
