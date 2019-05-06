// Show a triangle by pure QML
import QtQuick 2.0

Item {
    id : component
    //width: 100
    //height: 100

    property var listColors
    property int order: 0 // order of the bead on its line from left to right, 0 being left
    property string taskTurn: 'robot'
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
        if (taskTurn === "child"){
            if (this_row_nb === 0){
                listColors = ['#ffa600','red','blue', '#ffa600','red','blue','#ffa600','red']
                return (listColors[order])
            }

            else if (this_row_nb === 1){
                listColors = ['gray','gray','gray', 'gray','gray','gray','gray','gray']
                return (listColors[order])
            }
        }

        else if (taskTurn === "robot") {
            if (this_row_nb === 1){
                listColors = ['#ffa600','red','blue', '#ffa600','red','blue','#ffa600','red']
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



Canvas {
              id: triangle
              antialiasing: true

              property int triangleWidth: 60
              property int triangleHeight: 60
              property color strokeStyle:  "#ffffff"
              property color fillStyle: "#ffffff"
              property int lineWidth: 3
              property bool fill: false
              property bool stroke: true
              property real alpha: 1.0
              states: [
                  State {
                      name: "pressed"; when: ma1.pressed
                      PropertyChanges { target: triangle; fill: true; }
                  }
              ]

              onLineWidthChanged:requestPaint();
              onFillChanged:requestPaint();
              onStrokeChanged:requestPaint();

              signal clicked()

              onPaint: {
                  var ctx = getContext("2d");
                  ctx.save();
                  ctx.clearRect(0,0,triangle.width, triangle.height);
                  ctx.strokeStyle = triangle.strokeStyle;
                  ctx.lineWidth = triangle.lineWidth
                  ctx.fillStyle = triangle.fillStyle
                  ctx.globalAlpha = triangle.alpha
                  ctx.lineJoin = "round";
                  ctx.beginPath();

                  // put rectangle in the middle
                  ctx.translate( (0.5 *width - 0.5*triangleWidth), (0.5 * height - 0.5 * triangleHeight))

                  // draw the rectangle
                  ctx.moveTo(0,triangleHeight/2 ); // left point of triangle
                  ctx.lineTo(triangleWidth, 0);
                  ctx.lineTo(triangleWidth,triangleHeight);

                  ctx.closePath();
                  if (triangle.fill)
                      ctx.fill();
                  if (triangle.stroke)
                      ctx.stroke();
                  ctx.restore();
              }
              MouseArea{
                  id: ma1
                  anchors.fill: parent
                  onClicked: parent.clicked()
              }
}
