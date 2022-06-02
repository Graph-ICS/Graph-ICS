import QtQuick 2.15
import Theme 1.0

Rectangle {
    id: contentDelegate

    property alias textLabel: innerText
    property alias highlight: highlightAnimation

    signal highlightFinished
    state: 'normal'

    color: Theme.surface

    GText {
        id: innerText
        clip: true
        text: "placeholder Text"
        color: Theme.onsurface
        width: parent.width
        height: parent.height
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        antialiasing: true
    }

    Rectangle {
        id: overlay
        anchors.fill: parent
        color: Theme.onsurface
        opacity: 0.0
    }

    SequentialAnimation {
        id: highlightAnimation

        ParallelAnimation {
            ColorAnimation {
                target: contentDelegate
                property: "color"
                from: contentDelegate.color
                to: Theme.primary
                duration: 300
            }

            ColorAnimation {
                target: innerText
                property: "color"
                from: innerText.color
                to: Theme.onprimary
                duration: 300
            }
        }

        ParallelAnimation {
            ColorAnimation {
                target: contentDelegate
                property: "color"
                from: Theme.primary
                to: contentDelegate.color
                duration: 300
            }

            ColorAnimation {
                target: innerText
                property: "color"
                from: Theme.onprimary
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
                target: contentDelegate
                color: Theme.surface
                opacity: Theme.opacity.normal
            }

            PropertyChanges {
                target: innerText
                color: Theme.onsurface
                opacity: Theme.opacity.normal
            }
            PropertyChanges {
                target: overlay
                opacity: 0.0
            }
        },
        State {
            name: "hover"
            PropertyChanges {
                target: contentDelegate
                color: Theme.surface
                opacity: Theme.opacity.normal
            }

            PropertyChanges {
                target: innerText
                color: Theme.onsurface
                opacity: Theme.opacity.normal
            }
            PropertyChanges {
                target: overlay
                opacity: Theme.opacity.hover
            }
        },
        State {
            name: "press"
            PropertyChanges {
                target: contentDelegate
                color: Theme.surface
                opacity: Theme.opacity.normal
            }

            PropertyChanges {
                target: innerText
                color: Theme.onsurface
                opacity: Theme.opacity.normal
            }
            PropertyChanges {
                target: overlay
                opacity: Theme.opacity.pressed
            }
        },
        State {
            name: "pressAndHold"
            PropertyChanges {
                target: contentDelegate
                color: Theme.primary
                opacity: Theme.opacity.normal
            }

            PropertyChanges {
                target: innerText
                color: Theme.onprimary
                opacity: Theme.opacity.normal
            }
            PropertyChanges {
                target: overlay
                opacity: 0.0
            }
        },
        State {
            name: "transparent"
            PropertyChanges {
                target: contentDelegate
                color: "transparent"
                opacity: Theme.opacity.normal
            }
            PropertyChanges {
                target: innerText
                color: Theme.onsurface
                opacity: Theme.opacity.normal
            }
            PropertyChanges {
                target: overlay
                opacity: 0.0
            }
        },
        State {
            name: "disabled"
            PropertyChanges {
                target: contentDelegate
                color: Theme.surface
                opacity: Theme.opacity.disabled
            }

            PropertyChanges {
                target: innerText
                color: Theme.onsurface
                opacity: Theme.opacity.disabled
            }
            PropertyChanges {
                target: overlay
                opacity: 0.0
            }
        }
    ]
}
