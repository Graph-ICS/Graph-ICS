import QtQuick 2.0
import QtQuick.Dialogs 1.2

Item {
    id: graphics_FileDialog
    signal accepted(string fileUrl)

    FileDialog {
        id: fileDialog
        onAccepted: {
            graphics_FileDialog.accepted(fileUrl)
        }
    }

    states: [
        State {
            name: "open_json"
            PropertyChanges {
                target: fileDialog
                nameFilters: ["Json files (*.json)", "All files (*)"]
                selectExisting: true
            }
        },
        State {
            name: "save_json"
            PropertyChanges {
                target: fileDialog
                nameFilters: ["Json files (*.json)", "All files (*)"]
                selectExisting: false
            }
        },
        State {
            name: "save_image"
            PropertyChanges {
                target: fileDialog
                nameFilters: [ "Image files (*.png *.jpg)", "All files (*)" ]
                selectExisting: false
            }
        },

        State {
            name: "save_video"
            PropertyChanges {
                target: fileDialog
                nameFilters: ["Video files (*.mp4)", "All files (*)"]
                selectExisting: false
            }
        }
    ]

    function open(currentState){
        state = currentState
        fileDialog.open()
    }
}
