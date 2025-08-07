import QtQuick 2.15
import QtQuick.Controls 2.2


Item {
    id: button

    property var buttonText
    property int buttonWidth: 60
    property int buttonHeight: 60
    property color buttonColor: "lightgrey"
    property real buttonOpacity: 1.0
    property color textColor: "black"
    property color pressedColor: "#F7E425"
    property int textWeight: Font.Bold 

    width: buttonWidth
    height: buttonHeight

    signal clicked(string text)
    signal longPressed()
    Rectangle {
        id: rec
        width: button.buttonWidth
        height: button.buttonHeights
        color: mouseArea.pressed ? button.pressedColor : button.buttonColor
        radius: width / 2
        opacity: button.buttonOpacity
        anchors.fill:parent

    }
    Text {
        id: caption
        text: button.buttonText
        anchors.centerIn: parent
        color: button.textColor
        font.pixelSize: 24
        font.weight: button.textWeight
        font.family: "Open Sans"
    }
    MouseArea{
        id: mouseArea
        anchors.fill:parent
        onClicked:{
            button.clicked(buttonText);
        }
        // долгий тап
        pressAndHoldInterval: 600
        onPressAndHold: {
            button.longPressed()
        }    
    }
}

