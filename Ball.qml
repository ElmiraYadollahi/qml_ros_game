import QtQuick 2.0
import Box2D 2.0

import './shared/'
import Ros 1.0




Rectangle {

    id: ball

    // Property definitions
    property var listColors
    property int order: 0 // order of the bead on its line from left to right, 0 being left
    property string taskTurn: 'robot'
    property int this_row_nb
    property int box_nb
    property int ball_nb
    property int reset: 0


    // Functions
    function colorSelection(taskTurn, order){
        //console.log("my_row", this_row_nb);
        if (taskTurn === "robot"){
            if (this_row_nb === 0){
                listColors = ['#ffa600','#ffa600', '#ffa600','red','red','red','blue','blue','blue']
                return (listColors[order])
            }

            else if (this_row_nb === 1){
                listColors = ['gray','gray','gray', 'gray','gray','gray','gray','gray', 'gray']
                return (listColors[order])
            }
        }

        else if (taskTurn === "child") {
            if (this_row_nb === 1){
                listColors = ['#ffa600','#ffa600', '#ffa600','red','red','red','blue','blue','blue']
                return (listColors[order])
            }

            else if (this_row_nb === 0){
                listColors = ['gray','gray','gray', 'gray','gray','gray','gray','gray', 'gray']
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


    function randomoize(){

        for (var k=0; k<box_nb; k++){
            for (var j=0; j<object_nb; j++){
                ballRepeater.itemAt(j).x = abacusArea.width * 0.02 + Math.random() * abacusArea.width * 0.8
            }
        }
    }


    //////////////////////////////////////////////////////////////////////////
    // Publishers

   // RosStringPublisher {
   //     id: bead_sizePublisher
   //     topic: "bead/size"
   // }

    onXChanged:{
        ball_xChangePublisher.text = '' + x
        ball_radiusPublisher.text = '' + ball.radius
        box_widthPublisher.text = '' + abacusArea.width *0.98
        box_heightPublisher.text = '' + abacusArea.height * 0.49 - abacusArea.width *0.01
        box_maxRadiusPublisher.text = abacusArea.width * 0.02 + abacusArea.width * 0.1
        //row_countChangePublisher.text = ''+root.rowCounter
        //row_lengthPublisher.text = this_row.width - body.radius - body.radius * 0.3
        //bead_radiusPublisher.text = body.radius
    }

    onYChanged:{
        ball_yChangePublisher.text = '' + y
        //row_countChangePublisher.text = ''+root.rowCounter
        //row_lengthPublisher.text = this_row.width - body.radius - body.radius * 0.3
        //bead_radiusPublisher.text = body.radius
    }

    RosStringPublisher {
        id: ball_xChangePublisher
        topic: "box"+this_row_nb+"/ball"+order+"/xchange"
    }

    RosStringPublisher {
        id: ball_yChangePublisher
        topic: "box"+this_row_nb+"/ball"+order+"/ychange"
    }

    RosStringPublisher {
        id: ball_radiusPublisher
        topic: "box"+this_row_nb+"/ball"+order+"/radius"
    }

    RosStringPublisher {
        id: box_widthPublisher
        topic: "box" + this_row_nb + "/width"
    }

    RosStringPublisher {
        id: box_heightPublisher
        topic: "box" + this_row_nb + "/height"
    }

    RosStringPublisher {
        id: box_maxRadiusPublisher
        topic: "game/ball/max"
    }


    //////////////////////////////////////////////////////////////////////
    // Subscribers

    RosStringSubscriber {
        id: ball_xChangeSubscriber
        topic: "game/box" + this_row_nb + "/ball" + order + "/setX"

        onTextChanged:{
            ball.x = parseInt(text)
            //root.updateRowCounter()
        }
    }

    RosStringSubscriber {
        id: game_turnSubscriber
        topic: "game/turn"

        onTextChanged:{
            taskTurn = text
            //root.updateRowCounter()
        }
    }

    RosStringSubscriber {
        id: ball_yChangeSubscriber
        topic: "game/box" + this_row_nb + "/ball" + order + "/setY"

        onTextChanged:{
            ball.y = parseInt(text)
            //root.updateRowCounter()
        }
    }


    //objectName: "bead_"+my_row.index+ "_"+order
    property string name

    RosStringSubscriber {
        id: abacus_reset
        topic: "reset/order"
        onTextChanged:{
            reset = parseInt(text)
            if (reset === 1){
                randomoize()
            }
        }
    }

    RosStringSubscriber {
        id: abacus_row0_reset
        topic: "reset/row0/order"
        onTextChanged:{
            reset0 = parseInt(text)
            if (reset0 === 1){
                restartRow0()
            }
        }
    }

    x: abacusArea.width * 0.02 + Math.random() * abacusArea.width * 0.4
    y: abacusArea.width * 0.02 + Math.random() * abacusArea.height* 0.4
    width: abacusArea.width * 0.02 + Math.random() * abacusArea.width * 0.1
    height: width
    color: colorSelection(taskTurn, order)
    border.color: "white"
    radius: width/2

    MouseArea {
        anchors.fill: parent
        drag.target: ball
        drag.axis: disableMove()
        drag.minimumX: abacusArea.width *0.01
        drag.maximumX: abacusArea.width *0.98 - ball.width
        drag.minimumY: abacusArea.width *0.01
        drag.maximumY: abacusArea.height * 0.49 - abacusArea.width *0.01 - ball.width
    }
}


