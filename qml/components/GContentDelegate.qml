import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import Theme 1.0

Rectangle{
    id: graphics_contentDelegate

    property var colorState: QtObject {
        property var background: QtObject {
            property color normal: Theme.contentDelegate.color.background.normal
            property color hover: Theme.contentDelegate.color.background.hover
            property color press: Theme.contentDelegate.color.background.press
            property color pressAndHold: Theme.contentDelegate.color.background.pressAndHold
        }
        property var text: QtObject {
            property color normal: Theme.contentDelegate.color.text.normal
            property color hover: Theme.contentDelegate.color.text.hover
            property color press: Theme.contentDelegate.color.text.press
            property color pressAndHold: Theme.contentDelegate.color.text.pressAndHold
        }
    }

    property var font: QtObject {
        property string family: Theme.font.family
        property int pointSize: Theme.font.pointSize
    }
    property alias textHeight: innerText.implicitHeight
    property alias textWidth: innerText.implicitWidth
    property alias textLabel: innerText
    property alias highlight: highlightAnimation

    signal highlightFinished
    state: 'normal'

    QQC2.Label {
        id: innerText

        text: "placeholder Text"
        anchors.centerIn: parent
        font {
            family: graphics_contentDelegate.font.family
            pointSize: graphics_contentDelegate.font.pointSize
        }
    }

    SequentialAnimation{
        id: highlightAnimation

        ParallelAnimation {
            ColorAnimation{
                target: graphics_contentDelegate
                property: "color"
                from: graphics_contentDelegate.color
                to: graphics_contentDelegate.colorState.background.pressAndHold
                duration: 300
            }

            ColorAnimation {
                target: innerText
                property: "color"
                from: innerText.color
                to: graphics_contentDelegate.colorState.text.pressAndHold
                duration: 300
            }
        }

        ParallelAnimation {
            ColorAnimation{
                target: graphics_contentDelegate
                property: "color"
                from: graphics_contentDelegate.colorState.background.pressAndHold
                to: graphics_contentDelegate.color
                duration: 300
            }

            ColorAnimation {
                target: innerText
                property: "color"
                from: graphics_contentDelegate.colorState.text.pressAndHold
                to: innerText.color
                duration: 300
            }
        }
        onFinished: {
            highlightFinished()
        }
    }




    states: [
        State {
            name: "normal"
            PropertyChanges {
                target: graphics_contentDelegate
                color: colorState.background.normal
            }
            PropertyChanges {
                target: innerText
                color: graphics_contentDelegate.colorState.text.normal
            }
        },
        State {
            name: "hover"
            PropertyChanges {
                target: graphics_contentDelegate
                color: colorState.background.hover
            }
            PropertyChanges {
                target: innerText
                color: graphics_contentDelegate.colorState.text.hover
            }
        },
        State {
            name: "press"
            PropertyChanges {
                target: graphics_contentDelegate
                color: colorState.background.press
            }
            PropertyChanges {
                target: innerText
                color: graphics_contentDelegate.colorState.text.press
            }
        },
        State {
            name: "pressAndHold"
            PropertyChanges {
                target: graphics_contentDelegate
                color: colorState.background.pressAndHold
            }
            PropertyChanges {
                target: innerText
                color: graphics_contentDelegate.colorState.text.pressAndHold
            }
        },
        State {
            name: "transparent"
            PropertyChanges {
                target: graphics_contentDelegate
                color: "transparent"
            }
            PropertyChanges {
                target: innerText
                color: "transparent"
            }
        },
        State {
            name: "disabled"
            PropertyChanges {
                target: graphics_contentDelegate
                color: Theme.contentDelegate.color.background.disabled
            }
            PropertyChanges {
                target: innerText
                color: Theme.contentDelegate.color.text.disabled
            }
        }
    ]

}

