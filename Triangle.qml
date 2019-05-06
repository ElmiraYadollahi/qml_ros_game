// Show a triangle by pure QML
import QtQuick 2.0


import './shared/'
import Ros 1.0

Item {
    id : component
    //width: 100
    //height: 100

    property var listColors
    property int order: 0 // order of the bead on its line from left to right, 0 being left
    property string taskTurn: 'child'
    property int this_row_nb
    clip : true

    x: abacusArea.width * 0.02 + Math.random() * abacusArea.width * 0.4
    y: abacusArea.width * 0.02 + Math.random() * abacusArea.height* 0.4
    width: abacusArea.width * 0.02 + Math.random() * abacusArea.width * 0.1
    height: width
    color: colorSelection(taskTurn, order)
    //border.color: "white"
    //radius: width/2


    function colorSelection(taskTurn, order){
        //console.log("my_row", this_row_nb);
        if (taskTurn === "robot"){
            if (this_row_nb === 0){
                listColors = ['#ffa600','#ffa600', '#ffa600','red','red','red','blue','blue','blue']
                return (listColors[order])
            }

            else if (this_row_nb === 1){
                listColors = ['gray','gray','gray', 'gray','gray','gray','gray','gray']
                return (listColors[order])
            }
        }

        else if (taskTurn === "child") {
            if (this_row_nb === 1){
                listColors = ['#ffa600','#ffa600', '#ffa600','red','red','red','blue','blue','blue']
                return (listColors[order])
            }

            else if (this_row_nb === 0){
                listColors = ['gray','gray','gray', 'gray','gray','gray','gray','gray']
                return (listColors[order])
            }
        }



    }

    function disableMove(){
        if (taskTurn === "robot"){
            if (this_row_nb === 0){
                return (Drag.XandYAxis)
            }

            else if (this_row_nb === 1){
                return (0)
            }
        }
        else if (taskTurn === "child"){
            if (this_row_nb === 1){
                return (Drag.XandYAxis)
            }

            else if (this_row_nb === 0){
                return (0)
            }
        }
    }

    onXChanged:{
        tri_xChangePublisher.text = ''+x
        //row_countChangePublisher.text = ''+root.rowCounter
        //row_lengthPublisher.text = this_row.width - body.radius - body.radius * 0.3
        //bead_radiusPublisher.text = body.radius
    }

    onYChanged:{
        Tri_yChangePublisher.text = ''+x
        //row_countChangePublisher.text = ''+root.rowCounter
        //row_lengthPublisher.text = this_row.width - body.radius - body.radius * 0.3
        //bead_radiusPublisher.text = body.radius
    }

    RosStringPublisher {
        id: tri_xChangePublisher
        topic: "box"+this_row_nb+"/tri"+order+"/xchange"
    }

    RosStringPublisher {
        id: triangle_yChangePublisher
        topic: "box"+this_row_nb+"/tri"+order+"/ychange"
    }

    // The index of corner for the triangle to be attached
    property int corner : 0;
    property alias color : rect.color

    Rectangle {
        x : component.width * ((corner+1) % 4 < 2 ? 0 : 1) - width / 2
        y : component.height * (corner    % 4 < 2 ? 0 : 1) - height / 2
        id : rect
        color : "red"
        antialiasing: true
        width : Math.min(component.width,component.height)
        height : width
        transformOrigin: Item.Center
        rotation : 45
        scale : 1.414
        border.color: "white"
    }




    //width: 50; height: 50


    //color: "red"
    //opacity: (600.0 - rect.x) / 600




    MouseArea {
        anchors.fill: parent
        drag.target: component
        drag.axis: disableMove()
        drag.minimumX: abacusArea.width *0.01
        drag.maximumX: abacusArea.width *0.98 - component.width
        drag.minimumY: abacusArea.width *0.01
        drag.maximumY: abacusArea.height * 0.49 - abacusArea.width *0.01 - component.width
    }
}
