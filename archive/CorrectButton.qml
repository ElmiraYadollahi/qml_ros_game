import QtQuick 2.0

Item{


    Rectangle{
        id: rectangleButton
        property bool checked: false
        property alias text: buttonText.text
        Accessible.name: Text
        Accessible.description: "This button does " + text
        Accessible.role: Accessible.Button
        Accessible.onPressAction: {
            button.clicked()
        }

        signal checked

        width: buttonText.width + 50
        height: 60
        gradient: Gradient {
            GradientStop { position: 0.0; color: "lightgrey" }
            GradientStop { position: 1.0;
                color: Button.focus ? "red" : "darkgreen"}
        }
        radius: 10
        antialiasing: true
        //x: abacusArea.width * 1/8
        //y: abacusArea.height * 4/5


        Text {
            id: buttonText
            text: parent.description
            anchors.centerIn: parent
            font.pixelSize: parent.height * .5
            style: Text.Sunken
            color: "white"
            styleColor: "black"
        }


        MouseArea {
            id: mousearea
            anchors.fill: parent
            onClicked: parent.clicked()
        }

        Keys.onSpacePressed: clicked()

    }

    //change the color of the button in differen button states
    states: [
        State {
            name: "Hovering"
            PropertyChanges {
                target: rectangleButton
                color: hoverColor
            }
        },
        State {
            name: "Pressed"
            PropertyChanges {
                target: rectangleButton
                color: pressColor
            }
        }
    ]

    //define transmission for the states
    transitions: [
        Transition {
            from: ""; to: "Hovering"
            ColorAnimation { duration: 200 }
        },
        Transition {
            from: "*"; to: "Pressed"
            ColorAnimation { duration: 10 }
        }
    ]

    //Mouse area to react on click events
    MouseArea {
        hoverEnabled: true
        anchors.fill: button
        onEntered: { button.state='Hovering'}
        onExited: { button.state=''}
        onClicked: { button.clicked();}
        onPressed: { button.state="Pressed" }
        onReleased: {
            if (containsMouse)
              button.state="Hovering";
            else
              button.state="";
        }
    }

}
