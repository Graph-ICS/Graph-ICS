import QtQuick 2.15

import "../../components"

import Theme 1.0
import Global 1.0

GAttribute {
    id: textFieldAttribute

    property bool showFileButton: model ? model.getProperty(
                                              "showFileButton") : false
    property bool useIntValidator: model ? model.getProperty(
                                               "useIntValidator") : false
    property bool useDoubleValidator: model ? model.getProperty(
                                                  "useDoubleValidator") : false
    property var fileType: model ? model.getProperty("fileType") : ""

    property var fileButton: null

    width: {
        if (showFileButton) {
            return textField.width + fileButton.width
        }
        return nameText.width + textField.width
    }

    nameText.anchors.left: textField.right
    nameText.anchors.verticalCenter: textField.verticalCenter
    nameText.visible: !showFileButton

    onShowFileButtonChanged: {
        if (showFileButton) {
            fileButton = fileButtonComponent.createObject(textFieldAttribute)
        }
    }

    onUseIntValidatorChanged: {
        if (useIntValidator) {
            textField.validator = intValidatorComponent.createObject(textField)
        }
    }

    onUseDoubleValidatorChanged: {
        if (useDoubleValidator) {
            textField.validator = doubleValidatorComponent.createObject(
                        textField)
        }
    }

    GTextField {
        id: textField

        property int maxWidth: 100

        borderColor: Theme.primaryDark
        font: defaultFont

        enabled: {
            if (isLocked) {
                return false
            } else {
                if (showFileButton && fileType.toLowerCase() === "video") {
                    if (text != "" && !activeFocus) {
                        return !node.isPartOfStream
                    }
                }
            }
            return true
        }

        width: {
            if (showFileButton) {
                return 82
            }
            if (implicitWidth > maxWidth) {
                return maxWidth
            }
            return implicitWidth
        }
        height: parent.height

        placeholderText: showFileButton ? qsTr("Path") : ""
        text: defaultValue ? String(defaultValue) : ""

        onAccepted: {
            setValue(text)
        }

        onFocusChanged: {
            setValue(text)
        }
    }
    Component {
        id: fileButtonComponent
        GFileButton {
            visible: showFileButton
            enabled: textField.enabled
            anchors {
                left: textField.right
                verticalCenter: textField.verticalCenter
            }

            height: Theme.baseHeight
            width: height

            iconButton.icon.color: iconButton.hovered ? Theme.primaryDark : Theme.surface

            fileDialog.nameFilters: {
                if (fileType.toLowerCase() === "image") {
                    fileDialog.folder = fileDialog.shortcuts.pictures
                    return Global.imageFilesNameFilters
                }
                if (fileType.toLowerCase() === "video") {
                    fileDialog.folder = fileDialog.shortcuts.movies
                    return Global.videoFilesNameFilters
                }
                return []
            }

            onAccepted: {
                setValue(fileUrl)
            }
        }
    }

    Component {
        id: intValidatorComponent
        RegExpValidator {
            regExp: /^[0-9/]+$/
        }
    }

    Component {
        id: doubleValidatorComponent
        RegExpValidator {
            regExp: /^[0-9./]+$/
        }
    }

    onValueChanged: {
        textField.text = String(value)
    }
}
