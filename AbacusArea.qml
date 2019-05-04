import QtQuick 2.0
import Box2D 2.0
import './shared/'


Rectangle {
    id:abacusArea
    anchors.fill: parent
    property int nbRows: 2
    property int nbBeads: 10
    property real tolerance: abacusArea.height * 0.01

    function counterLevel(rowCn){
        console.log("width", abacusArea.width);
        console.log("height", abacusArea.height);
        if (rowCn.row_nb === 0)
            return (rowCn.rowCounter)
        else if (rowCn.row_nb === 1)
            return (rowCn.rowCounter * 10)
        else
            return (rowCn.rowCounter * 100)
    }

    // The top box
    Rectangle {
        x: 0
        y: 0
        width: abacusArea.width *0.99
        height: abacusArea.height * 0.49
        border.width : abacusArea.width *0.01
        border.color : "#955196"
        color: 'transparent'
    }

    // The divider
    Rectangle {
        x: (abacusArea.width *0.99) /2
        y: 0
        width: abacusArea.width *0.005
        height: abacusArea.height * 0.49
        border.width : abacusArea.width *0.0025
        border.color : "#955196"
        color: 'transparent'
    }

    // The bootom box
    Rectangle {
        x: 0
        y: abacusArea.height * 0.49 + tolerance
        width: abacusArea.width *0.99
        height: abacusArea.height * 0.49
        border.width : abacusArea.width *0.01
        border.color : "#444e86"
        color: 'transparent'
    }

    // The divider
    Rectangle {
        x: (abacusArea.width *0.99) /2
        y: abacusArea.height * 0.49 + tolerance
        width: abacusArea.width *0.005
        height: abacusArea.height * 0.49
        border.width : abacusArea.width *0.0025
        border.color : "#444e86"
        color: 'transparent'
    }

   // Creates the objects for each box
    Repeater{
            id: objectRepeater
            model: nbRows

            AbacusRow{
                id: this_row
                row_nb: index
                color: 'transparent'
                x: index
                y: this_row.height *index
                height: abacusArea.height/(2)
                width: abacusArea.width *0.99 - height
                onReset: root.restartRowsNow()
                }


        }
}
