import QtQuick 2.0
//import Box2D 2.0

import './shared/'
import Ros 1.0


Rectangle {
    id: square

    property var listColors
    property int order: 0 // order of the bead on its line from left to right, 0 being left
    property string taskTurn
    property int this_row_nb
    property int reset: 0
    property int box_nb
    property int collect: 0
    property int counter: 0


    function colorSelection(taskTurn, order){
        //console.log("my_row", this_row_nb);
        if (taskTurn === "child"){
            if (this_row_nb === 0){
                listColors = ['#ffa600','#ffa600', '#ffa600','red','red','red','red','blue','blue']
                return (listColors[order])
            }

            else if (this_row_nb === 1){
                listColors = ['gray','gray','gray', 'gray','gray','gray','gray','gray','gray']
                return (listColors[order])
            }
        }

        else if (taskTurn === "robot") {
                if (this_row_nb === 1){
                    listColors = ['#ffa600','#ffa600', '#ffa600','red','red','red','red','blue','blue']
                    return (listColors[order])
                }

                else if (this_row_nb === 0){
                    listColors = ['gray','gray','gray', 'gray','gray','gray','gray','gray','gray']
                    return (listColors[order])
                }
            }
        else if (taskTurn === "null"){
            listColors = ['gray','gray','gray', 'gray','gray','gray','gray','gray', 'gray']
            return (listColors[order])
        }



    }

    function disableMove(){
        if (taskTurn === "child"){
            if (this_row_nb === 0){
                return (Drag.XandYAxis)
            }

            else if (this_row_nb === 1){
                return (0)
            }
        }

        else if (taskTurn === "robot"){
            if (this_row_nb === 1){
                return (Drag.XandYAxis)
            }

            else if (this_row_nb === 0){
                return (0)
            }

        }
        else if (taskTurn === "null"){
                return (0)


        }
    }

    function randomoize(){

        for (var k=0; k<box_nb; k++){
            for (var j=0; j<object_nb_s; j++){
                squareRepeater.itemAt(j).x = positionRandomizerSquare(j)
                squareRepeater.itemAt(j).y = abacusArea.width * 0.02 + Math.random() * abacusArea.height* 0.32
            }
        }
    }

    function positionRandomizerSquare(ind){
        if ( ind === 0 | ind === 3 | ind === 4 ){
            return (abacusArea.width * 0.02 + Math.random() * abacusArea.width * 0.4)
        }
        else if (ind === 1 | ind === 2 | ind === 5 | ind === 6){
            return (abacusArea.width * 0.5 + Math.random() * abacusArea.width * 0.4)
        }
    }




    //////////////////////////////////////////////////////////////////////////
    // Publishers


    onXChanged:{
        if (counter > 100){
            something_xChangePublisher.text = '' + x
            counter = 0
        }
        counter = counter + 1


        square_xChangePublisher.text = '' + x
        square_sidePublisher.text = '' + square.width
        //row_countChangePublisher.text = ''+root.rowCounter
        //row_lengthPublisher.text = this_row.width - body.radius - body.radius * 0.3
        //bead_radiusPublisher.text = body.radius
    }

    onCollectChanged: {
        square_xChangePublisher.text = '' + x
        square_sidePublisher.text = '' + square.width
        square_yChangePublisher.text = '' + y
    }

    onYChanged:{
        //something_xChangePublisher.text = '' + x
        square_yChangePublisher.text = '' + y
        //row_countChangePublisher.text = ''+root.rowCounter
        //row_lengthPublisher.text = this_row.width - body.radius - body.radius * 0.3
        //bead_radiusPublisher.text = body.radius
    }

    RosStringPublisher {
        id: square_xChangePublisher
        topic: "box"+this_row_nb+"/quadrado"+order+"/xchange"
    }

    RosStringPublisher {
        id: square_yChangePublisher
        topic: "box"+this_row_nb+"/quadrado"+order+"/ychange"
    }

    RosStringPublisher {
        id: square_sidePublisher
        topic: "box"+this_row_nb+"/quadrado"+order+"/side"
    }

    RosStringPublisher {
        id: something_xChangePublisher
        topic: "box/something/change"
    }


    //////////////////////////////////////////////////////////////////////
    // Subscribers

    RosStringSubscriber {
        id: publish_everything
        topic: "collect/positions"
        onTextChanged:{
            collect = parseInt(text)
            }
        }


    RosStringSubscriber {
        id: square_xChangeSubscriber
        topic: "game/box" + this_row_nb + "/quadrado" + order + "/setX"

        onTextChanged:{
            square.x = parseInt(text)
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
        id: square_yChangeSubscriber
        topic: "game/box" + this_row_nb + "/quadrado" + order + "/setY"

        onTextChanged:{
            square.y = parseInt(text)
            //root.updateRowCounter()
        }
    }

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
        id: change_balls
        topic: "reset/level/numbers"
        onTextChanged:{
            if (text === "facil"){
                object_nb_c = 3
                object_nb_s = 3
            }
            if (text === "medio"){
                object_nb_c = 4
                object_nb_s = 7
            }
            if (text === "dificil"){
                object_nb_c = 9
                object_nb_s = 9
            }
        }
    }


    //width: 50; height: 50

    //x: positionRandomizer(index)
    y: abacusArea.width * 0.02 + Math.random() * abacusArea.height* 0.4
    //x: positionRandomizer()
    //y: abacusArea.width * 0.02 + Math.random() * abacusArea.height* 0.4
    //width: abacusArea.width * 0.02 + Math.random() * abacusArea.width * 0.1
    x: abacusArea.width * 0.02 + Math.random() * abacusArea.width * 0.4
    //y: abacusArea.width * 0.02 + Math.random() * abacusArea.height* 0.4
    height: width
    rotation: Math.random() * 360
    color: colorSelection(taskTurn, order)
    border.color: "white"
    //color: "red"
    //opacity: (600.0 - rect.x) / 600

    MouseArea {
        anchors.fill: parent
        drag.target: square
        drag.axis: disableMove()
        drag.minimumX: abacusArea.width *0.01
        drag.maximumX: abacusArea.width *0.98 - square.width
        drag.minimumY: abacusArea.width *0.01
        drag.maximumY: abacusArea.height * 0.49 - abacusArea.width *0.01 - square.width
    }



}
