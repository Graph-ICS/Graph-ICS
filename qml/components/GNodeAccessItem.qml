import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQml.Models 2.12

// import qml folder
import "../"


// ComboboxItem und ToolbarItem merged
// drag n drop der nodes in die canvas

MouseArea {
    id: dragArea

    property Rectangle container: null
    property Component thisComponent: null
    property GMenu menu: null
    property bool held: false
    property alias textLabel: content.textLabel
    property alias content: content
    property string text: "nodeName"

    property bool horizontal: true

    property var absolutePos: null
    property var thisNode: null

    property bool dragPossible: false
    property bool isDragging: false

    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.RightButton

    height: horizontal ? container.height : textLabel.font.pointSize + 32
    width: horizontal ? textLabel.implicitWidth + 12 : container.width

    anchors {
        top: horizontal ? thisComponent.top : undefined
        bottom: horizontal ? thisComponent.bottom : undefined

        left: horizontal ? undefined :  thisComponent.left
        right: horizontal ? undefined : thisComponent.right
    }

    onPressed: {
        forceActiveFocus()
        if(mouse.button == Qt.RightButton){
            if(menu != null){
                menu.popup()
                content.state = 'press'
            }
        } else {
            if(!held){
                content.state = 'press'
                dragPossible = true
            }

        }
    }

    onEntered: {
        if(!held)
            content.state = 'hover'
    }

    onReleased: {
        if(containsMouse)
            content.state = 'hover'
        else
            content.state = 'normal'

        dragPossible = false
        isDragging = false

        if(thisNode != null){
            nodeWarning.showWarning(thisNode)
            dropNode()
        }
    }
    onExited: {
        if(!held)
            content.state = 'normal'
    }


    onPositionChanged: {
        if(!held){
            if(!containsMouse){
                if(dragPossible){
                    isDragging = true
                    dragPossible = false

                    canvas.resetSelectedNodes()

                    thisNode = createNode(textLabel.text)

                    thisNode.scale = 0.5
                    absolutePos = getAbsolutePosition(dragArea)
                }
            }
            if(thisNode != null){
                thisNode.x = absolutePos.x + mouseX - thisNode.width / 2
                thisNode.y = absolutePos.y +  mouseY - thisNode.height / 2
            }
        }
    }

    GContentDelegate {
        id: content
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
        textLabel.text: text

        textLabel.anchors{
            leftMargin: horizontal ? undefined : 10
            centerIn: horizontal ? content : undefined
            left: horizontal ? undefined : content.left
            verticalCenter: horizontal ? undefined : content.verticalCenter
        }

        state: 'normal'
        width: dragArea.width
        height: dragArea.height
        Drag.active: dragArea.held
        Drag.source: dragArea
        Drag.hotSpot.x: width / 2
        Drag.hotSpot.y: height / 2
    }

    function dropNode() {
        var portWidth = 0
        thisNode.parent = canvas

        thisNode.x -= sidePanel.width
        thisNode.y -= favoritesBar.height + menuBar.height

        if(thisNode.inPorts.length > 0){
            portWidth = thisNode.portOut.viewPort.width/2
        }

        // falls  die Maus auserhalb der Canvas released wird
        thisNode.x = Math.max(0 + portWidth, thisNode.x)
        thisNode.x = Math.min(canvas.width - thisNode.width - thisNode.portOut.viewPort.width/2, thisNode.x)
        thisNode.y = Math.max(0, thisNode.y)
        thisNode.y = Math.min(canvas.height -thisNode.height, thisNode.y)

        thisNode.scale = 1

        canvas.nodes.push(thisNode);
        menuManager.updateConfig();
        thisNode = null
        resizeCanvas()
    }

    function getAbsolutePosition(node) {
          var returnPos = {};
          returnPos.x = 0;
          returnPos.y = 0;
          if(node !== undefined && node !== null) {
              var parentValue = getAbsolutePosition(node.parent);
              returnPos.x = parentValue.x + node.x;
              returnPos.y = parentValue.y + node.y;
          }
          return returnPos;
    }
}
