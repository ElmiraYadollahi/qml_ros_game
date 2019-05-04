import QtQuick 2.0
import Box2D 2.0

import './shared/'
import Ros 1.0


Rectangle {
    id:rect
    visible: true
    radius: 110
    property int my_row // line row on which the bead is place with 0 being the first row
    property int order: 0 // order of the bead on its line from left to right, 0 being left
    property var listColors: ['black','forestgreen','blueviolet']
    property Body body: body
    property int reset: 0
    property int oldBeadX: 0
    property int newBeadX: 0
    property int count_index: 0
    signal buttonCorrect
    signal pressedBead(var rect)

    Connections {
        target: wrongButton
        onClicked: {
            button_wrongPulisher.text = "wrong"
        }
    }

    Connections {
        target: correctButton
        onClicked: {
            button_correctPulisher.text = "correct"
        }
    }

    Connections {
        target: resetButton
        onClicked: {
            button_resetPulisher.text = "reset"
            restartRows()
        }
    }

    function restartRows(){

        for (var k=0; k<nbRows; k++){
            //console.log("my_row", my_row);
            for (var j=0; j<nbBeads; j++){
                //rectRepeater.itemAt(j).my_row = k
                rectRepeater.itemAt(j).x = root.x+ width /2  + width *j
            }
        }
    }

    function restartRow0(){

        for (var k=0; k<1; k++){
            //console.log("bead.location", k);
            for (var j=0; j<nbBeads; j++){
                rectRepeater.itemAt(j).x = root.x+ width /2  + width *j
            }
        }
    }

    RosStringPublisher {
        id: bead_sizePublisher
        topic: "bead/size"
    }

    onXChanged:{
        bead_xChangePublisher.text = ''+x
        row_countChangePublisher.text = ''+root.rowCounter
        row_lengthPublisher.text = this_row.width - body.radius - body.radius * 0.3
        bead_radiusPublisher.text = body.radius
    }

    RosStringPublisher {
        id: bead_xChangePublisher
        topic: "abacus/row"+my_row+"/bead"+order+"/xchange"
    }

    RosStringPublisher {
        id: row_countChangePublisher
        topic: "abacus/row"+my_row+"/count"
    }

    RosStringPublisher {
        id: row_lengthPublisher
        topic: "abacus/row/length"
    }

    RosStringPublisher {
        id: bead_radiusPublisher
        topic: "abacus/bead/radius"
    }

    RosStringPublisher {
        id: button_correctPulisher
        topic: "abacus/button/correct"
    }

    RosStringPublisher {
        id: button_wrongPulisher
        topic: "abacus/button/wrong"
    }

    RosStringPublisher {
        id: button_resetPulisher
        topic: "abacus/button/reset"
    }

    RosStringSubscriber {
        id: bead_xChangeSubscriber
        topic: "abacus/row"+my_row+"/bead"+order+"/setX"

        onTextChanged:{
            rect.x = parseInt(text)
            root.updateRowCounter()
        }
    }

    objectName: "bead_"+my_row.index+ "_"+order
    property string name

    RosStringSubscriber {
        id: abacus_reset
        topic: "reset/order"
        onTextChanged:{
            reset = parseInt(text)
            if (reset === 1){
                restartRows()
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

    function randomColor(row_index, count_index) {
        if(row_index ===  0)
            if (count_index === 1)
            //return Qt.rgba(0.7, 0.13, 0.13, 1);
            //return Qt.rgba(0.82 ,0 , 0, 1);
            //return Qt.rgba(1 ,0.39 , 0.38, 1);
                return Qt.rgba(1 ,1 , 1, 1);
            else
                return Qt.rgba(0 ,0.25 , 0.36, 1);

        else if(row_index ===  1)
            //return Qt.rgba(0.13 ,0.54 , 0.1, 1);
            //return Qt.rgba(0.73 ,0.33 , 0.83, 1);
            //return Qt.rgba(1 ,0.54 , 0, 1);
            //return Qt.rgba(0.34 ,0.31 , 0.65, 1);
            if (count_index === 1)
                return Qt.rgba(1 ,1 , 1, 1);
            else
                return Qt.rgba(0.74 ,0.31 , 0.56, 1);
        else
            //return Qt.rgba(0, 0, 0.54, 1);
            //return Qt.rgba(0, 0, 0.8, 1);
            //return Qt.rgba(0.82, 0.41, 0.11, 1);
            return Qt.rgba(1 ,0.65 , 0, 1);
    }

    gradient: Gradient {
        GradientStop { position: 0.0; color: randomColor(my_row, count_index) }
        GradientStop { position: 0.7; color: randomColor(my_row, count_index) }
        GradientStop { position: 1.0; color: "gray" }
    }

    RosStringPublisher{
        id:collisionPub

    }

    function randomObject(count_index){
        if(count_index ===  0)
            return Qt.rgba(0 ,0.25 , 0.36, 1);
    }

    /*BoxBody {
        id:body
        target: rect
        world: physicsWorld
        fixedRotation: true
        sleepingAllowed: true
        bodyType: Body.Dynamic
        //radius: width / 2
        width: 10
        height: 10
        density: 100
        friction: 1000
        restitution: 0


        signal send()
        onSend:{
            row_lengthPublisher.text = this_row.width - body.radius - body.radius * 0.3
            bead_radiusPublisher.text = body.radius
        }

        Component.onCompleted: body.send()
    }*/

    Rectangle {
        id: rectangle

        //x: 40 + Math.random() * 720
        //y: 40 + Math.random() * 520
        width: 20 + Math.random() * 100
        height: 20 + Math.random() * 100
        rotation: Math.random() * 360
        color: randomColor()
        border.color: randomColor()
        //smooth: true

        Body {
            id: rectangleBody

            target: rectangle
            world: physicsWorld
            bodyType: Body.Dynamic

            Box {
                width: rectangle.width
                height: rectangle.height
                density: 0.5
                restitution: 0.5
                friction: 0.5
            }
        }

       /* MouseArea {
            anchors.fill: parent
            propagateComposedEvents: true
            onPressed: {
                mouse.accepted = false;
                pressedBody = rectangleBody;
            }
        }*/
    }

    BoxBody{
        id: wall_right
        target: rect
        world: physicsWorld

        fixedRotation:true
        sleepingAllowed: false
        bodyType: Body.Static
        x: abacusArea.width - 40
        width: 32
        height: window.height
        restitution: 0
    }

    BoxBody{
        id: wall_bottom
        target: rect
        world: physicsWorld

        fixedRotation:true
        sleepingAllowed: false
        bodyType: Body.Static
        y: abacusArea.height * 0.49 - 20
        width: abacusArea.width - 20
        height: 32
        restitution: 0
    }

    MouseArea {
        anchors.fill: rect
        propagateComposedEvents: true
        onPressed: {
            mouse.accepted = false;
            pressedBead(rect);
            body.bodyType = Body.Dynamic
            console.log("BodyType", "Dynamic")
            console.log("maxposition", parseInt(this_row.width - body.radius - body.radius * 0.3))
        }
        onEntered: console.log("Send")
        onReleased: {
            body.bodyType = Body.Static
            console.log("BodyType", "Static")
            console.log("maxposition", this_row.width - body.radius - body.radius * 0.3)
            mouse.accepted = true;
        }
    }
}

