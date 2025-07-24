import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.15
import Calculator 1.0 

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Calculator")

    Calculated {
        id: calcEngine
    }

    // Храним текущее выражение
    property string currentText: ""

    // Функция для обновления текста (добавление цифры или оператора)
    function updateText(inputText) {
        if (currentText === "0" || currentText === "") {
            currentText = inputText;  // Если пусто или ноль, заменяем
        } else {
            currentText += inputText;  // Иначе добавляем к существующему
        }
    }

    // Функция для очистки
    function clearCalculator() {
        calcEngine.clearSolution();  // Очищаем решение в C++
        currentText = "";  // Очищаем поле ввода
    }

    // Функция для обработки вычисления
    function calculateResult() {
        calcEngine.calc(currentText);  // Передаём текущее выражение в C++
        currentText = calcEngine.solution;  // Получаем результат и сохраняем в currentText
    }

    GridLayout {
        id: grid
        columns: 4
        rows: 6
        anchors.fill: parent


        AreaTextItem {
            id: textDisplay
            Layout.column: 0
            Layout.row: 0
            Layout.alignment: Qt.AlignCenter
            Layout.columnSpan: 4
            text: currentText.length > 0 ? currentText : calcEngine.solution  // Показываем выражение или результат
            fontSize: 36
        }

        // Кнопки цифр
        CalcButton {
            buttonText: "1"
            width:100
            height:100
            Layout.column: 0
            Layout.row: 1
            Layout.alignment: Qt.AlignCenter
            onClicked: updateText(buttonText)
        }
        CalcButton {
            buttonText: "2"
            width:100
            height:100
            Layout.column: 1
            Layout.row: 1
            Layout.alignment: Qt.AlignCenter
            onClicked: updateText(buttonText)
        }
        CalcButton {
            buttonText: "3"
            width:100
            height:100
            Layout.column: 2
            Layout.row: 1
            Layout.alignment: Qt.AlignCenter
            onClicked: updateText(buttonText)
        }
        CalcButton {
            buttonText: "4"
            width:100
            height:100
            Layout.column: 0
            Layout.row: 2
            Layout.alignment: Qt.AlignCenter
            onClicked: updateText(buttonText)
        }
        CalcButton {
            buttonText: "5"
            width:100
            height:100
            Layout.column: 1
            Layout.row: 2
            Layout.alignment: Qt.AlignCenter
            onClicked: updateText(buttonText)
        }
        CalcButton {
            buttonText: "6"
            width:100
            height:100
            Layout.column: 2
            Layout.row: 2
            Layout.alignment: Qt.AlignCenter
            onClicked: updateText(buttonText)
        }
        CalcButton {
            buttonText: "7"
            width:100
            height:100
            Layout.column: 0
            Layout.row: 3
            Layout.alignment: Qt.AlignCenter
            onClicked: updateText(buttonText)
        }
        CalcButton {
            buttonText: "8"
            width:100
            height:100
            Layout.column: 1
            Layout.row: 3
            Layout.alignment: Qt.AlignCenter
            onClicked: updateText(buttonText)
        }
        CalcButton {
            buttonText: "9"
            width:100
            height:100
            Layout.column: 2
            Layout.row: 3
            Layout.alignment: Qt.AlignCenter
            onClicked: updateText(buttonText)
        }
        CalcButton {
            buttonText: "0"
            width:100
            height:100
            Layout.column: 0
            Layout.row: 4
            Layout.alignment: Qt.AlignCenter
            onClicked: updateText(buttonText)
        }

        // Кнопки операций
        CalcButton {
            buttonText: "+"
            width:100
            height:100
            Layout.column: 3
            Layout.row: 1
            Layout.alignment: Qt.AlignCenter
            onClicked: updateText(buttonText)
        }
        CalcButton {
            buttonText: "-"
            width:100
            height:100
            Layout.column: 3
            Layout.row: 2
            Layout.alignment: Qt.AlignCenter
            onClicked: updateText(buttonText)
        }
        CalcButton {
            buttonText: "*"
            width:100
            height:100
            Layout.column: 3
            Layout.row: 3
            Layout.alignment: Qt.AlignCenter
            onClicked: updateText(buttonText)
        }
        CalcButton {
            buttonText: "/"
            width:100
            height:100
            Layout.column: 3
            Layout.row: 4
            Layout.alignment: Qt.AlignCenter
            onClicked: updateText(buttonText)
        }

        // Кнопка вычисления
        CalcButton {
            buttonText: "="
            width:100
            height:100
            Layout.column: 1
            Layout.row: 4
            Layout.alignment: Qt.AlignCenter
            onClicked: calculateResult()  // Обработка вычислений
        }

        // Кнопка очистки
        CalcButton {
            buttonText: "C"
            width:100
            height:100
            Layout.column: 2
            Layout.row: 4
            Layout.alignment: Qt.AlignCenter
            onClicked: clearCalculator()
        }
    }
}
