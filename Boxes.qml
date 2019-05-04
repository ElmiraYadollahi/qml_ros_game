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
        if (taskTurn === "child"){
            if (this_row_nb === 0){
                listColors = ['#ffa600','red','blue', '#ffa600','red','blue','red','blue']
                return (listColors[order])
            }

            else if (this_row_nb === 1){
                listColors = ['gray','gray','gray', 'gray','gray','gray','gray','gray']
                return (listColors[order])
            }
        }

        else if (taskTurn === "robot") {
                if (this_row_nb === 1){
                    listColors = ['#ffa600','red','blue', '#ffa600','red','blue','red','blue']
                    return (listColors[order])
                }

                else if (this_row_nb === 0){
                    listColors = ['gray','gray','gray', 'gray','gray','gray','gray','gray']
                    return (listColors[order])
                }
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
    }

    //width: 50; height: 50
    x: abacusArea.width * 0.02 + Math.random() * abacusArea.width * 0.4
    y: abacusArea.width * 0.02 + Math.random() * abacusArea.height* 0.4
    width: abacusArea.width * 0.02 + Math.random() * abacusArea.width * 0.1
    height: abacusArea.width * 0.02 + Math.random() * abacusArea.width * 0.1
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
