import QtQuick 2.15

import Backend 1.0

Item {
    id: taskInitializer

    property bool isInitialized: false
    property GTask task
    property var tasks: {
        "Image": {
            "model": imageTaskModel,
            "item": imageTask
        },
        "Video": {
            "model": videoTaskModel,
            "item": videoTask
        },
        "Camera": {
            "model": cameraTaskModel,
            "item": cameraTask
        }
    }

    Component {
        id: imageTaskModel
        ImageTask {}
    }
    GImageTask {
        id: imageTask
    }

    Component {
        id: videoTaskModel
        VideoTask {}
    }
    GVideoTask {
        id: videoTask
    }

    Component {
        id: cameraTaskModel
        CameraTask {}
    }
    GCameraTask {
        id: cameraTask
    }

    function init(nodeModel, taskName) {
        if (isInitialized) {
            console.debug("Task already initialized!")
            return false
        }

        let inputNode = nodeModel.getInputNode()
        let inputType = inputNode.getType()

        if (inputType !== Node.INPUT) {
            let failureNode = canvas.getNode(inputNode)
            failureNode.printUserMessage("I need an input!")
            return false
        }

        let inputName = inputNode.getName()
        let model = tasks[inputName]["model"].createObject(this)

        if (!model) {
            return false
        }
        model.init(nodeModel)
        scheduler.add(model)

        task = tasks[inputName]["item"]
        task.model = model
        task.type = inputName
        task.name = taskName

        // get the port type of the view
        // to disable editing if type is GData
        task.portType = nodeModel.getInPortType(0)

        isInitialized = true
        return true
    }

    function deinit() {
        if (!isInitialized) {
            console.log("Nothing to deinitialize")
            return
        }

        task.model.destroy()
        task.model = null
        task.type = ""
        task = null
        isInitialized = false
    }
}
