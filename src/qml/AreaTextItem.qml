import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: areaTextItem
    width: parent.width
    height: 156

    property string expression: ""  
    property string result: "0"      

    property int smallFontSize: 20
    property int largeFontSize: 50

    property color backgroundColor: "#04BFAD"
    property int textWeight: Font.DemiBold


    Rectangle {
        anchors.fill: parent
        color: backgroundColor
        radius: 20  

        Rectangle {
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            height: parent.height / 2  
            color: backgroundColor
            radius: 0
        }
        Label {
            id: expressionLabel
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 40
            }
            font.pixelSize: smallFontSize
            font.weight: areaTextItem.textWeight
            color: "white"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideLeft
            text: expression.length > 0 ? expression : "0"
            height: smallFontSize * 1.5
        }

        Label {
            id: resultLabel
            anchors {
                left: parent.left
                right: parent.right
                top: expressionLabel.bottom
                bottom: parent.bottom
                margins: 40
            }
            font.pixelSize: largeFontSize
            font.weight: areaTextItem.textWeight
            color: "white"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideLeft
            text: result
        }
    }
}
