import QtQuick 2.0
import Box2D 2.0
import './shared/'

Rectangle {
    id:root
    property int row_nb // index of this row
    property int nbBeads: 5 // sets the number of bead per row
    property int width_empty: Math.floor(this_row.width * 0.4)/10 // defines the size of the empty space in a row
    property int rowCounter :0
    property int temp_width: 0
    property int mid_point: 0
    property int tolerance: 20
    property Body pressedBody: null
    readonly property int wallMeasure: 40

    signal reset

    function randomColor() {
        return Qt.rgba(Math.random(), Math.random(), Math.random(), Math.random());
    }

    // BOX2D WORLD
    World {
        id: physicsWorld
        gravity: Qt.point(0.0, 0.0);
        enableContactEvents: true

    }

    WindowBoundaries {}

    MouseJoint {
        id: mouseJoint
        bodyA: anchor
        dampingRatio: 0.8
        maxForce: 100
    }


    MouseArea {
        id: mouseArea
        anchors.fill: parent

        onPressed: {
            if (pressedBody != null) {
                mouseJoint.maxForce = pressedBody.getMass() * 500;
                mouseJoint.target = Qt.point(mouseX, mouseY);
                mouseJoint.bodyB = pressedBody;
            }
        }

        onPositionChanged: {
            mouseJoint.target = Qt.point(mouseX, mouseY);
            drag.maximumX = this_row.width - 20

        }

        onReleased: {
            mouseJoint.bodyB = null;
            pressedBody = null;
        }
    }

    Body {
        id: anchor
        world: physicsWorld
    }

    /*Repeater{
        id:beadRepeater
        model:nbBeads
        Bead {
            id:bead
            x: 40 + Math.random() * 720
            y: 40 + Math.random() * 520
            //anchors.verticalCenter: root.verticalCenter
            rotation: 0
            width: parseInt(root.width/(nbBeads*2) - width_empty)
            height: width
            order: index
            my_row: root.row_nb
            count_index: index
            onPressedBead: pressedBody = bead.body
            onXChanged:{
                root.updateRowCounter()
            }
        }

    }*/

    /*Repeater{
        id:rectRepeater
        model:nbBeads

        CorrectButton {
            id:rect
            x: 40 + Math.random() * 720
            y: 40 + Math.random() * 520
            //anchors.verticalCenter: root.verticalCenter
            rotation: 0
            width: parseInt(root.width/(nbBeads*2) - width_empty)
            height: width
            order: index
            my_row: root.row_nb
            count_index: index
            onPressedBead: pressedBody = rect.body
            onXChanged:{
                root.updateRowCounter()
            }
        }
    }*/


    Repeater {
        model: 9
        Boxes {
            id: boxes
            x: abacusArea.width * 0.02 + Math.random() * abacusArea.width * 0.8
            y: abacusArea.width * 0.02 + Math.random() * abacusArea.height* 0.35
            width: abacusArea.width * 0.03 + Math.random() * abacusArea.width * 0.05
            height: width
            rotation: 0
            order: index
            this_row_nb :row_nb

        }

    }

    Repeater {
        model: 9
        Ball {
            id: ball
            x: abacusArea.width * 0.02 + Math.random() * abacusArea.width * 0.8
            y: abacusArea.width * 0.02 + Math.random() * abacusArea.height* 0.35
            rotation: 0
            width: abacusArea.width * 0.03 + Math.random() * abacusArea.width * 0.05
            height: width
            order: index
            this_row_nb :row_nb
        }

    }

    /*Repeater {
        model: 8
       Triangle {
            id: tri
            x: abacusArea.width * 0.02 + Math.random() * abacusArea.width * 0.8
            y: abacusArea.width * 0.02 + Math.random() * abacusArea.height* 0.35
            rotation: 0
            width: abacusArea.width * 0.03 + Math.random() * abacusArea.width * 0.05
            height: width
            order: index
            this_row_nb :row_nb
        }

    }*/


}
