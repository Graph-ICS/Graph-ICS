import QtQuick 2.12
import QtQuick.Controls 2.12
import Theme 1.0
ComboBox {
    id: control
    model: ListModel {

    }

    delegate: ItemDelegate {
        width: control.width
        height: 24
        contentItem: Text {
            id: txt
            text: name
            color: Theme.textField.color.text.normal
            font.family: Theme.font.family
            font.pointSize: Theme.font.pointSize
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            color: Theme.textField.color.background.normal
            Rectangle {
                anchors.top: parent.top
                height: 1
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                color: Theme.textField.color.text.normal
            }
        }

//        highlighted: control.highlightedIndex === index
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
            function onPressedChanged() { canvas.requestPaint(); }
        }

        onPaint: {
            context.reset();
            context.moveTo(0, 0);
            context.lineTo(width, 0);
            context.lineTo(width / 2, height);
            context.closePath();
            context.fillStyle = Theme.textField.color.text.normal
            context.fill();
        }
    }

    contentItem: Text {
        id: text
        leftPadding: 0
        rightPadding: control.indicator.width + control.spacing
        horizontalAlignment: Text.AlignHCenter
        text: control.displayText
        font.family: Theme.font.family
        font.pointSize: Theme.font.pointSize
        color: Theme.textField.color.text.normal
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: text.implicitWidth + 28
        implicitHeight: 24
//        border.color: control.pressed ? "orange" : "yellow"
//        border.width: 4
        color: Theme.textField.color.background.normal
        radius: 1
    }

    popup: Popup {
        y: control.height - 1
        width: control.width
        implicitHeight: contentItem.implicitHeight
        padding: 0

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex
            interactive: false
            ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle {
            border.color: Theme.textField.color.background.normal
            radius: 1
        }
    }
}
