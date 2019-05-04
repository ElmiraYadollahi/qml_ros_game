import QtQuick 2.0

Rectangle{
    id: button
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
