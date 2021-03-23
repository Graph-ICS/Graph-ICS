import QtQuick 2.15
import QtCharts 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls 1.4 as QQC1
import QtQuick.Layouts 1.15
import Theme 1.0
import QtGraphicalEffects 1.12
import "../components/"


Item {
    id: area

    property var defaultView: null

    property var views: []
    property int minWidth:  gridView.columns * 20

    GridView {
        id: gridView
        property int lines: 1
        property int columns: 1

        anchors.fill: parent

        delegate: GView {
            width: gridView.cellWidth; height: gridView.cellHeight
            backgroundColor: viewColor
        }
        model: ListModel {
            id: viewsModel
//            ListElement {
//                viewColor: Theme.viewArea.colors[0]
//            }
//            ListElement {
//                viewColor: Theme.viewArea.colors[1]
//            }
        }

        flow: GridView.FlowTopToBottom
        cellHeight: parent.height / lines
        cellWidth: parent.width / columns
        interactive: false
    }

    function addViews(number){
        if(viewsModel.count < number){
            for(var add = viewsModel.count; add < number; add++){
                viewsModel.append({"viewColor": Theme.viewArea.colors[add]})
            }
        } else {
            // count > number
            for(var remove = viewsModel.count-1; remove >= number; remove--){
                var view = gridView.itemAtIndex(remove)
                if(view === null){
                    continue
                }

                view.removeNodeConnection()
                viewsModel.remove(remove)
            }
        }

        if(viewsModel.count % 3 == 0){
            var div = viewsModel.count / 3
            gridView.lines = div
            gridView.columns = 3
            return
        }

        if(viewsModel.count % 2 == 0){
            var div2 = viewsModel.count / 2
            gridView.columns = div2
            gridView.lines = 2
            return
        }

        gridView.lines = 1
        gridView.columns = viewsModel.count
    }

    function setGridCells(columns, lines){
        gridView.lines = lines
        gridView.columns = columns
    }

    function getAllConnectedNodes(){
        var nodes = []
        var i = 0
        while(i < viewsModel.count){
            var view = gridView.itemAtIndex(i)
            if(view === null){
                break
            }

            i++
            if(view.connectedNode === null){
                continue
            }

            nodes.push(view.connectedNode)
        }
        return nodes
    }

    function getViewForNode(node){
        var i = 0
        while(i < viewsModel.count){
            var view = gridView.itemAtIndex(i)
            if(view === null){
                break
            }

            i++
            if(view.connectedNode === null){
                continue
            }
            if(view.connectedNode === node){
                return view
            }
        }
        return null
    }

    function clearAll(){
        var i = 0
        while(i < viewsModel.count){
            var view = gridView.itemAtIndex(i)
            if(view === null){
                break
            }
            view.clearView()
            i++
        }
    }

    function clearShown(node){
        var i = 0
        while(i < viewsModel.count){
            var view = gridView.itemAtIndex(i)
            if(view === null){
                break
            }
            if(view.connectedNode === node){
                view.clearView()
            }
            i++
        }
        node.isShown = false
    }

    function updateViews(node, result){
        var i = 0
        while(i < viewsModel.count){
            var view = gridView.itemAtIndex(i)
            if(view === null){
                break
            }

            if(view.connectedNode === node){
                view.updateView(result)
            }
            i++
        }
    }

    function checkShownFlag(node, excludedView){
        var i = 0
        while(i < viewsModel.count){
            var view = gridView.itemAtIndex(i)
            if(view === null){
                break
            }
            i++
            if(view === excludedView){
                continue
            }
            if(view.connectedNode === node){
                return view.nodeShown
            }
        }
        return false
    }

    function removeNode(node){
        var i = 0
        while(i < viewsModel.count){
            var view = gridView.itemAtIndex(i)
            if(view === null){
                break
            }
            if(view.connectedNode === node){
                view.connectedNode = null
            }
            i++
        }
    }

    function saveViewNodeConnection(){
        var connection = []
        var i = 0
        while(i < viewsModel.count){
            var view = gridView.itemAtIndex(i)
            if(view === null){
                break
            }
            i++
            if(view.connectedNode === null){
                continue
            }
            connection.push({"viewIndex": i-1, "nodeTitle": view.connectedNode.title.title})
        }
        return connection
    }

    function viewAt(index){
        return gridView.itemAtIndex(index)
    }

}
