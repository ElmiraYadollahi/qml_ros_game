import QtQuick 2.0
//import Box2D 2.0

import './shared/'
import Ros 1.0


Rectangle {
    id: tinyBox

    property var listColors
    property int order: 0 // order of the bead on its line from left to right, 0 being left
    property string taskTurn: 'robot'
    property int this_row_nb

    function colorSelection(taskTurn, order){
        //console.log("my_row", this_row_nb);
        if (taskTurn === "robot"){
            if (this_row_nb === 0){
                listColors = ['#ffa600','#ffa600', '#ffa600','red','red','red','blue','blue','blue']
                return (listColors[order])
            }

            else if (this_row_nb === 1){
                listColors = ['gray','gray','gray', 'gray','gray','gray','gray','gray','gray']
                return (listColors[order])
            }
        }

        else if (taskTurn === "child") {
                if (this_row_nb === 1){
                    listColors = ['#ffa600','#ffa600', '#ffa600','red','red','red','blue','blue','blue']
                    return (listColors[order])
                }

                else if (this_row_nb === 0){
                    listColors = ['gray','gray','gray', 'gray','gray','gray','gray','gray','gray']
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

    //////////////////////////////////////////////////////////////////////////
    // Publishers


    onXChanged:{
        square_xChangePublisher.text = '' + x
        square_sidePublisher.text = '' + tinyBox.width
        //row_countChangePublisher.text = ''+root.rowCounter
        //row_lengthPublisher.text = this_row.width - body.radius - body.radius * 0.3
        //bead_radiusPublisher.text = body.radius
    }

    onYChanged:{
        square_yChangePublisher.text = '' + y
        //row_countChangePublisher.text = ''+root.rowCounter
        //row_lengthPublisher.text = this_row.width - body.radius - body.radius * 0.3
        //bead_radiusPublisher.text = body.radius
    }

    RosStringPublisher {
        id: square_xChangePublisher
        topic: "box"+this_row_nb+"/square"+order+"/xchange"
    }

    RosStringPublisher {
        id: square_yChangePublisher
        topic: "box"+this_row_nb+"/square"+order+"/ychange"
    }

    RosStringPublisher {
        id: square_sidePublisher
        topic: "box"+this_row_nb+"/square"+order+"/side"
    }


    //////////////////////////////////////////////////////////////////////
    // Subscribers


    RosStringSubscriber {
        id: square_xChangeSubscriber
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
        id: square_yChangeSubscriber
        topic: "game/box" + this_row_nb + "/ball" + order + "/setY"

        onTextChanged:{
            ball.y = parseInt(text)
            //root.updateRowCounter()
        }
    }

    //width: 50; height: 50
    x: abacusArea.width * 0.02 + Math.random() * abacusArea.width * 0.4
    y: abacusArea.width * 0.02 + Math.random() * abacusArea.height* 0.4
    width: abacusArea.width * 0.02 + Math.random() * abacusArea.width * 0.1
    height: width
    rotation: Math.random() * 360
    color: colorSelection(taskTurn, order)
    border.color: "white"
    //color: "red"
    //opacity: (600.0 - rect.x) / 600

    MouseArea {
        anchors.fill: parent
        drag.target: tinyBox
        drag.axis: disableMove()
        drag.minimumX: abacusArea.width *0.01
        drag.maximumX: abacusArea.width *0.98 - tinyBox.width
        drag.minimumY: abacusArea.width *0.01
        drag.maximumY: abacusArea.height * 0.49 - abacusArea.width *0.01 - tinyBox.width
    }



}
