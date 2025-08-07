import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.15
import Calculator 1.0

Window {
    id: root
    visible: true
    title: qsTr("Calculator")
    minimumWidth: 360
    minimumHeight: 610
    color: "#024873"

    property bool secretModeWaiting: false
    property string secretInput: ""

    Calculated {
        id: calcEngine
    }

    property string currentText: "0"

    function isDigit(ch) {
        return /^[0-9]$/.test(ch)
    }

    function inputDigit(d) {
        if (secretModeWaiting) {
            secretInput += d
            if (secretInput.length > 3)
                secretInput = secretInput.slice(secretInput.length - 3)
            if (secretInput === "123") {
                secretModeWaiting = false
                secretModeTimer.stop()
                openSecretMenu()
                return
            }
        }

        if (currentText === "0") {
            currentText = d
        } else {
            currentText += d
        }
    }

    function inputDot() {

        var m = currentText.match(/([0-9]*\.?[0-9]*)$/)
        var last = m ? m[0] : ""
        if (last.indexOf(".") !== -1) {
            return 
        }
        if (currentText === "" || /[+\-*/÷]$/.test(currentText)) {
            currentText += "0."
        } else if (currentText === "0") {
            currentText = "0."
        } else {
            currentText += "."
        }
    }


    function inputOperator(op) {
        if (currentText === "" && op === "-") {
            currentText = "-"
            return
        }
        if (/[+\-*/÷]$/.test(currentText)) {
            currentText = currentText.slice(0, -1) + op
        } else {
            currentText += op
        }
    }

    function clearCalculator() {
        calcEngine.clearSolution()
        currentText = "0"
    }

    function calculateResult() {
        if (/[+\-*/÷]$/.test(currentText)) {
            currentText = currentText.slice(0, -1)
        }
        var expr = currentText.replace(/÷/g, "/")
        calcEngine.calc(expr)     
        calcEngine.calculate()     

    }

    function wrapExpression() {
        if (currentText === "" || currentText === "0") {
            currentText = "()"
            return
        }
        currentText = "(" + currentText + ")"
    }

    function insertLeftParen() {
        if (currentText === "0") currentText = "("
        else currentText += "("
    }

    function insertRightParen() {
        var opened = (currentText.match(/\(/g) || []).length
        var closed = (currentText.match(/\)/g) || []).length
        if (opened > closed && !/[+\-*/÷(]$/.test(currentText)) {
            currentText += ")"
        } else {
        }
    }

    function inputPercent() {
        let match = currentText.match(/([\d.]+)\s*([+\-*/])\s*([\d.]*)$/);
        if (match) {
            let base = parseFloat(match[1]);
            let percentValue = parseFloat(match[3]) || 0;
            let calculated = base * percentValue / 100;
            currentText = currentText.replace(/([\d.]+)$/, calculated.toString());
        } else {
            let num = parseFloat(currentText) || 0;
            currentText = (num / 100).toString();
        }
    }

    function toggleSign() {
        if (/^-?\d+(\.\d+)?$/.test(currentText)) {
            if (currentText.charAt(0) === "-")
                currentText = currentText.slice(1)
            else
                currentText = "-" + currentText
            return
        }

        var re = /([+\-*/÷])(-?\d+(\.\d+)?)$/
        var m = currentText.match(re)
        if (m) {
            var op = m[1]
            var numStr = m[2]
            if (numStr.charAt(0) === "-") {
                var newNum = numStr.slice(1)
                currentText = currentText.slice(0, m.index) + op + newNum
            } else {
                if (op === "+") {
                    currentText = currentText.slice(0, m.index) + "-" + numStr
                } else if (op === "-") {
                    currentText = currentText.slice(0, m.index) + "+" + numStr
                } else {
                    currentText = currentText.slice(0, m.index) + op + "(-" + numStr + ")"
                }
            }
            return
        }
    }

    function openSecretMenu() {
        stackView.push(secretMenuPage)
    }

    Timer {
        id: secretModeTimer
        interval: 5000
        running: false
        repeat: false
        onTriggered: {
            secretModeWaiting = false
            secretInput = ""
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: mainPage
    }

    Component{
        id: secretMenuPage

        Item {
            visible: false

            Rectangle {
                anchors.fill: parent
                color: "#024873"

                Column {
                    anchors.centerIn: parent
                    spacing: 20

                    Label {
                        text: "Секретное меню"
                        font.pixelSize: 30
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Button {
                        text: "Назад"
                        onClicked: {
                            stackView.pop()
                        }
                    }
                }
            }
        }

    }

    Component {
        id: mainPage

        Item {

            AreaTextItem {
                id: textDisplay
                expression: currentText
                result: calcEngine.solution.length > 0 && calcEngine.solution !== "Ошибка" ? calcEngine.solution : "0"
                width: parent.width
                height: 156 
            }
            Item{
                anchors {
                    top: textDisplay.bottom
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                    margins: 24
                }

Popup {
    id: parenPopup
    modal: true
    focus: true
    visible: false
    width: parent.width
    height: parent.height
    background: Rectangle {
        color: "#00000080"
    }

    Rectangle {
        width: 120
        height: 104
        anchors.centerIn: parent
        color: "#024873"
        radius: 10
        border.color: "#0889A6"
        border.width: 2

        Column {
            anchors.centerIn: parent
            spacing: 8

            Button {
                text: "("
                font.pixelSize: 20
                width: 100
                height: 40
                background: Rectangle {
                    color: "#0889A6"
                    radius: 6
                }
                onClicked: {
                    insertLeftParen()
                    parenPopup.close()
                }
            }

            Button {
                text: ")"
                font.pixelSize: 20
                width: 100
                height: 40
                background: Rectangle {
                    color: "#0889A6"
                    radius: 6
                }
                onClicked: {
                    insertRightParen()
                    parenPopup.close()
                }
            }
        }
    }

    onClosed: visible = false
}




                GridLayout {
                    id: grid
                    anchors.fill: parent
                    columns: 4
                    rows: 5
                    columnSpacing: 24
                    rowSpacing: 24

                    CalcButton {
                        buttonText: ""
                        buttonColor: "#0889A6"
                        textColor: "#FFFFFF"
                        fontSize: 30
                        Layout.column: 0; Layout.row: 0
                        Layout.fillWidth: true; Layout.fillHeight: true
                        Layout.alignment: Qt.AlignCenter

                        Item {
                            anchors.fill: parent

                            Image {
                                source: "assets/bkt.svg"
                                width: 30
                                height: 30
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                anchors.centerIn: parent
                            }
                        }

                        onClicked: wrapExpression()
                        onLongPressed: parenPopup.open()
                    }
                    CalcButton {
                        buttonText: ""
                        buttonColor: "#0889A6"
                        textColor: "#FFFFFF"
                        fontSize: 30
                        Layout.column: 1; Layout.row: 0
                        Layout.fillWidth: true; Layout.fillHeight: true

                        Item {
                            anchors.fill: parent

                            Image {
                                source: "assets/plus_minus.svg"
                                width: 30
                                height: 30
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                anchors.centerIn: parent
                            }
                        }

                        onClicked: toggleSign()
                    }
                    CalcButton {
                        buttonText: ""
                        buttonColor: "#0889A6"
                        textColor: "#FFFFFF"
                        fontSize: 30
                        Layout.column: 2; Layout.row: 0
                        Layout.fillWidth: true; Layout.fillHeight: true

                        Item {
                            anchors.fill: parent

                            Image {
                                source: "assets/percent.svg"
                                width: 30
                                height: 30
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                anchors.centerIn: parent
                            }
                        }

                        onClicked: inputPercent()
                    }
                    CalcButton {
                        buttonText: ""
                        buttonColor: "#0889A6"
                        textColor: "#FFFFFF"
                        fontSize: 30
                        Layout.column: 3; Layout.row: 0
                        Layout.fillWidth: true; Layout.fillHeight: true

                        Item {
                            anchors.fill: parent

                            Image {
                                source: "assets/division.svg"
                                width: 30
                                height: 30
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                anchors.centerIn: parent
                            }
                        }

                        onClicked: inputOperator("÷")
                    }

                    CalcButton { 
                        buttonText: "" 
                        buttonColor: "#0889A6"
                        textColor: "#FFFFFF"
                        fontSize: 30
                        Layout.column: 3
                        Layout.row: 1
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Item {
                            anchors.fill: parent

                            Image {
                                source: "assets/multiply.svg"
                                width: 30
                                height: 30
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                anchors.centerIn: parent
                            }
                        }

                        onClicked: inputOperator("*") 
                    }
                    CalcButton { 
                        buttonText: ""
                        buttonColor: "#0889A6"
                        textColor: "#FFFFFF"
                        fontSize: 30 
                        Layout.column: 3
                        Layout.row: 2; Layout.fillWidth: true
                        Layout.fillHeight: true

                        Item {
                            anchors.fill: parent

                            Image {
                                source: "assets/minus.svg"
                                width: 30
                                height: 30
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                anchors.centerIn: parent
                            }
                        }

                        onClicked: inputOperator("-") 
                    }
                    CalcButton {
                        buttonText: ""
                        buttonColor: "#0889A6"
                        textColor: "#FFFFFF"
                        fontSize: 30 
                        Layout.column: 3
                        Layout.row: 3
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Item {
                            anchors.fill: parent

                            Image {
                                source: "assets/plus.svg"
                                width: 30
                                height: 30
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                anchors.centerIn: parent
                            }
                        }

                        onClicked: inputOperator("+")
                    }

                    CalcButton {
                        buttonText: ""
                        buttonColor: "#0889A6"
                        textColor: "#FFFFFF"
                        fontSize: 30
                        Layout.column: 3; Layout.row: 4
                        Layout.fillWidth: true; Layout.fillHeight: true

                        Item {
                            anchors.fill: parent

                            Image {
                                source: "assets/equal.svg"
                                width: 30
                                height: 30
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                anchors.centerIn: parent
                            }
                        }
                        
                        onClicked: {
                            if (!secretModeWaiting) {
                                calculateResult()
                            }
                        }
                        onLongPressed: {
                            secretModeWaiting = true
                            secretInput = ""
                            secretModeTimer.start()
                            console.log("Долгое нажатие, режим ввода кода активирован")
                        }
                    }
                    CalcButton {
                        buttonText: "C"
                        buttonColor: "#fbafac"
                        textColor: "#FFFFFF"
                        Layout.column: 0; Layout.row: 4
                        Layout.fillWidth: true; Layout.fillHeight: true
                        onClicked: clearCalculator()
                    }

                    CalcButton { 
                        buttonText: "7" 
                        textColor: "#024873"
                        Layout.column: 0
                        Layout.row: 1
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        onClicked: inputDigit("7") 
                    }
                    CalcButton { 
                        buttonText: "8"
                        textColor: "#024873"
                        Layout.column: 1
                        Layout.row: 1
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        onClicked: inputDigit("8") 
                    }
                    CalcButton { 
                        buttonText: "9"
                        textColor: "#024873"
                        Layout.column: 2
                        Layout.row: 1
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        onClicked: inputDigit("9") 
                    }

                    CalcButton { 
                        buttonText: "4"
                        textColor: "#024873"
                        Layout.column: 0
                        Layout.row: 2
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        onClicked: inputDigit("4") 
                    }
                    CalcButton { 
                        buttonText: "5"
                        textColor: "#024873"
                        Layout.column: 1
                        Layout.row: 2
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        onClicked: inputDigit("5") 
                    }
                    CalcButton { 
                        buttonText: "6"
                        textColor: "#024873"
                        Layout.column: 2
                        Layout.row: 2
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        onClicked: inputDigit("6") 
                    }

                    CalcButton { 
                        buttonText: "1"
                        textColor: "#024873"
                        Layout.column: 0
                        Layout.row: 3
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        onClicked: inputDigit("1") 
                    }
                    CalcButton { 
                        buttonText: "2"
                        textColor: "#024873"
                        Layout.column: 1
                        Layout.row: 3
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        onClicked: inputDigit("2") 
                    }
                    CalcButton { 
                        buttonText: "3"
                        textColor: "#024873"
                        Layout.column: 2
                        Layout.row: 3
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        onClicked: inputDigit("3") 
                    }

                    CalcButton {
                        buttonText: "0"
                        textColor: "#024873"
                        Layout.column: 1; Layout.row: 4
                        Layout.fillWidth: true; Layout.fillHeight: true
                        onClicked: inputDigit("0")
                    }
                    CalcButton {
                        buttonText: "."
                        textColor: "#024873"
                        Layout.column: 2; Layout.row: 4
                        Layout.fillWidth: true; Layout.fillHeight: true
                        onClicked: inputDot()
                    }
                }
            }
        }
    }

}
