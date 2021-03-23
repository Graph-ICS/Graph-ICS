import QtQuick 2.0
import QtQuick.Controls 2.15
import Theme 1.0

Item {

    property int leftMargin: 8
    property int topMargin: 12
    signal viewsChanged(int value)

    property alias viewsValue: viewSpinBox.value

    height: viewSpinBox.height + topMargin
    GSpinBox {
        id: viewSpinBox
        anchors.left: parent.left
        anchors.leftMargin: leftMargin
        from: 1
        to: 10
        stepSize: 1
        onValueChanged: {
            viewsChanged(value)
        }
    }
    Label {
        id: viewLabel
        anchors.left: viewSpinBox.right
        anchors.verticalCenter: viewSpinBox.verticalCenter
        anchors.leftMargin: leftMargin
        text: "Number of Views"
        font.family: Theme.font.family
        font.pointSize: Theme.font.pointSize
        color: Theme.contentDelegate.color.text.hover
    }
}
