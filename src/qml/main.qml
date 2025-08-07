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
    minimumHeight: 616
    color: "#024873"
    Calculated {
        id: calcEngine
    }

    property string currentText: "0"

    function isDigit(ch) {
        return /^[0-9]$/.test(ch)
    }

    function inputDigit(d) {
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
        if (calcEngine.solution.length > 0 && calcEngine.solution !== "Ошибка") {
            currentText = calcEngine.solution
        } else if (calcEngine.solution === "Ошибка") {
            currentText = "0"
        }
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

    Item {
        anchors.fill: parent

        AreaTextItem {
            id: textDisplay
            text: currentText
            fontSize: 36
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
            x: (root.width - width) / 2
            y: (root.height - height) / 2
            width: 200
            height: 120
            visible: false

            Rectangle {
                anchors.fill: parent
                color: "#ffffff"
                radius: 8
                border.color: "#cccccc"

                Column {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 8

                    Button {
                        text: "("
                        onClicked: {
                            insertLeftParen()
                            parenPopup.close()
                        }
                    }
                    Button {
                        text: ")"
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
                    buttonText: "()"
                    buttonColor: "#0889A6"
                    textColor: "#FFFFFF"
                    Layout.column: 0; Layout.row: 0
                    Layout.fillWidth: true; Layout.fillHeight: true
                    Layout.alignment: Qt.AlignCenter
                    onClicked: wrapExpression()
                    onLongPressed: parenPopup.open()
                }
                CalcButton {
                    buttonText: "+/-"
                    buttonColor: "#0889A6"
                    textColor: "#FFFFFF"
                    Layout.column: 1; Layout.row: 0
                    Layout.fillWidth: true; Layout.fillHeight: true
                    onClicked: toggleSign()
                }
                CalcButton {
                    buttonText: "%"
                    buttonColor: "#0889A6"
                    textColor: "#FFFFFF"
                    Layout.column: 2; Layout.row: 0
                    Layout.fillWidth: true; Layout.fillHeight: true
                    onClicked: inputPercent()
                }
                CalcButton {
                    buttonText: "÷"
                    buttonColor: "#0889A6"
                    textColor: "#FFFFFF"
                    Layout.column: 3; Layout.row: 0
                    Layout.fillWidth: true; Layout.fillHeight: true
                    onClicked: inputOperator("÷")
                }

                CalcButton { 
                    buttonText: "*" 
                    Layout.column: 3
                    Layout.row: 1
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    onClicked: inputOperator("*") 
                }
                CalcButton { 
                    buttonText: "-" 
                    Layout.column: 3
                    Layout.row: 2; Layout.fillWidth: true
                    Layout.fillHeight: true
                    onClicked: inputOperator("-") 
                }
                CalcButton { 
                    buttonText: "+" 
                    Layout.column: 3
                    Layout.row: 3; Layout.fillWidth: true
                    Layout.fillHeight: true
                    onClicked: inputOperator("+") 
                }

                CalcButton {
                    buttonText: "="
                    Layout.column: 3; Layout.row: 4
                    Layout.fillWidth: true; Layout.fillHeight: true
                    onClicked: calculateResult()
                }
                CalcButton {
                    buttonText: "C"
                    buttonColor: "#F25E5E"
                    buttonOpacity: 0.5
                    textColor: "#FFFFFF"
                    Layout.column: 0; Layout.row: 4
                    Layout.fillWidth: true; Layout.fillHeight: true
                    onClicked: clearCalculator()
                }

                CalcButton { 
                    buttonText: "7" 
                    Layout.column: 0
                    Layout.row: 1
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    onClicked: inputDigit("7") 
                }
                CalcButton { 
                    buttonText: "8" 
                    Layout.column: 1
                    Layout.row: 1
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    onClicked: inputDigit("8") 
                }
                CalcButton { 
                    buttonText: "9" 
                    Layout.column: 2
                    Layout.row: 1
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    onClicked: inputDigit("9") 
                }

                CalcButton { 
                    buttonText: "4" 
                    Layout.column: 0
                    Layout.row: 2
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    onClicked: inputDigit("4") 
                }
                CalcButton { 
                    buttonText: "5" 
                    Layout.column: 1
                    Layout.row: 2
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    onClicked: inputDigit("5") 
                }
                CalcButton { 
                    buttonText: "6" 
                    Layout.column: 2
                    Layout.row: 2
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    onClicked: inputDigit("6") 
                }

                CalcButton { 
                    buttonText: "1" 
                    Layout.column: 0
                    Layout.row: 3
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    onClicked: inputDigit("1") 
                }
                CalcButton { 
                    buttonText: "2" 
                    Layout.column: 1
                    Layout.row: 3
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    onClicked: inputDigit("2") 
                }
                CalcButton { 
                    buttonText: "3" 
                    Layout.column: 2
                    Layout.row: 3
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    onClicked: inputDigit("3") 
                }

                CalcButton {
                    buttonText: "0"
                    Layout.column: 1; Layout.row: 4
                    Layout.fillWidth: true; Layout.fillHeight: true
                    onClicked: inputDigit("0")
                }
                CalcButton {
                    buttonText: "."
                    Layout.column: 2; Layout.row: 4
                    Layout.fillWidth: true; Layout.fillHeight: true
                    onClicked: inputDot()
                }
            }
        }

    }
}
