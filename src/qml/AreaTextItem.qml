import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.15
import Calculator 1.0

Item {
    id: areaTextItem
    property alias text: viewText.text
    property int fontSize: viewText.font.pixelSize

    width: 550
    height: 50

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
        color: "lightgreen"
        border.color: "black" 

        Label {
            id: viewText
            text: calcEngine.solution
            font.pixelSize: fontSize
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            rightPadding: 10
            leftPadding: 10

            // Сигнал изменения размера
            onTextChanged: adjustFontSize()

            // Функция для динамического уменьшения шрифта
            function adjustFontSize() {
                var textWidth = viewText.width
                var containerWidth = areaText.width // учтены отступы

                // Уменьшаем размер шрифта, если текст не помещается
                while (textWidth > containerWidth && viewText.font.pixelSize > 8) {
                    viewText.font.pixelSize -= 1
                    textWidth = viewText.width // Пересчитываем ширину текста после изменения шрифта
                }
            }
        }
    }
}
