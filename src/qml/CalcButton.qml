import QtQuick 2.15
import QtQuick.Controls 2.2


Item {
    id: button

    property var buttonText
    property int buttonWidth
    property int buttonHeight
    property color color: "lightgrey"

    width: buttonWidth
    height: buttonHeight

    signal clicked(string text)

    Rectangle {
        id: rec
        width: button.buttonWidth
        height: button.buttonHeight
        color: mouseArea.containsPress ? Qt.darker (button.color, 1.1) : button.color
        radius: 10
        anchors.fill:parent

        Text {
            id: caption
            text: button.buttonText
            anchors.centerIn: parent
            color: "black"
            font.pixelSize: 25
        }
        MouseArea{
            id: mouseArea
            anchors.fill:parent
            onClicked:{
                button.clicked(buttonText);
            }
        }
    }
}

