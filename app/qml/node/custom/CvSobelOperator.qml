import QtQuick 2.15
import QtQuick.Layouts 1.15

// Import our Theme
import Theme 1.0

import "../"
import "../attribute"
import "../../components"

// Import the c++ model
import Model.CvSobelOperator 1.0

// GNode provides a Component interface that can be used for customization
// GNode provides all functionality and default Components
GNode {
    id: sobel
    // Instantiate the c++ model and assign it to the model property
    model: CvSobelOperatorModel {}

    // Override the background
    // Do not specitfy size or anchors of the Rectangle, as it will fit to the content
    background: Rectangle {
        color: Theme.primary
        radius: 8
        border.width: 3
        border.color: {
            if (isSelected) {
                return Theme.secondary
            }
            if (isHovered) {
                return Theme.secondaryLight
            }
            return Theme.primaryDark
        }
    }

    // Override the content
    // Everything a sobel contains is inside of the content Component
    // e.g. Title and Attributes
    // Specify a size for this Component if no implicit size is available (e.g. Item)
    // You don't need to use Layouts (but they are convenient for sizing)
    content: ColumnLayout {
        spacing: Theme.smallSpacing
        // Display the node name (id)
        Text {
            Layout.fillWidth: true
            text: id
            font: Theme.font.body2
            color: Theme.onprimary

            topPadding: Theme.largeSpacing
            leftPadding: Theme.largeSpacing
            rightPadding: Theme.largeSpacing
            bottomPadding: Theme.smallSpacing
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
        RowLayout {
            Layout.leftMargin: Theme.largeSpacing
            Layout.rightMargin: Theme.smallSpacing
            Layout.fillHeight: true
            Item {
                Layout.preferredHeight: xDerivative.height + yDerivative.height
                                        + Theme.smallSpacing
                Layout.minimumWidth: Math.max(xDerivative.width,
                                              yDerivative.width)
                // Specify the Attributes
                // Custom Attributes that derive from GAttribute can be used too
                TextFieldAttribute {
                    id: xDerivative
                    // make sure to use the exact same name as in registerAttribute(...) (c++)
                    name: "xDerivative"
                    // get the attribute model from the node model by the name
                    node: sobel
                    model: node.model.getAttribute(name)
                    // Don't forget to add the Attributes to the attributes array
                    // Otherwise saving and loading the node will not work properly
                    // It is necessary to use the onCompleted function to push the
                    // attribute into the array, because content is a Component
                    // and the content object is only created during GNode's onCompleted function
                    Component.onCompleted: attributes.push(xDerivative)
                }
                TextFieldAttribute {
                    id: yDerivative
                    anchors.top: xDerivative.bottom
                    anchors.topMargin: Theme.smallSpacing
                    name: "yDerivative"
                    node: sobel
                    model: node.model.getAttribute(name)
                    Component.onCompleted: attributes.push(yDerivative)
                }
            }
            // Simple demonstration
            // swap the attribute values
            GIconButton {
                Layout.preferredHeight: Theme.baseHeight
                Layout.preferredWidth: Theme.baseHeight

                // Make sure that the attribute values can not be altered if the node is locked
                // Otherwise unexpected behavior may occur if the values are changed
                // while a stream is processing
                enabled: !isLocked

                icon.source: Theme.icon.swapVert
                icon.color: {
                    if (hovered || pressed) {
                        return Theme.primaryDark
                    }
                    return Theme.onprimary
                }

                transparent: true

                onClicked: {
                    let value = xDerivative.value
                    xDerivative.setValue(yDerivative.value)
                    yDerivative.setValue(value)
                }
            }
        }
    }

    // If you just want to create your individual Attributes and don't want to override the content
    // you can just override the predefined attribute Components e.g.:
    // textFieldAttributeComponent: MyCustomTextFieldAttribute {}
}
