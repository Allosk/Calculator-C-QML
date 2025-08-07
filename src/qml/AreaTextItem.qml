import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.15
import Calculator 1.0

Item {
    id: areaTextItem
    property alias text: viewText.text
    property int fontSize: viewText.font.pixelSize
    Calculated {
        id: calcEngine
    }

    function calculat(){
        calcEngine.calc(viewText.text);
    }


    Rectangle {
        id: areaText
        width: parent.width
        height: parent.height
        color: "transparent"
        clip: true

        // Верхняя часть — прямоугольник без скругления
        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height - 32  // высота минус удвоенный радиус
            color: "#04BFAD"
            radius: 0
        }

        // Нижняя часть — прямоугольник со скругленными углами
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 64  // двойной радиус (2 * 32)
            color: "#04BFAD"
            radius: 32
        }

        Label {
            id: viewText
            text: calcEngine.solution
            font.pixelSize: fontSize
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            rightPadding: 20
            leftPadding: 10

            onTextChanged: adjustFontSize()

            function adjustFontSize() {
                var textWidth = viewText.width
                var containerWidth = areaText.width

                while (textWidth > containerWidth && viewText.font.pixelSize > 8) {
                    viewText.font.pixelSize -= 1
                    textWidth = viewText.width
                }
            }
        }
    }


}
