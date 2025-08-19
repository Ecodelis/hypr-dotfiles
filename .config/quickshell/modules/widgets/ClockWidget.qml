// ClockWidget.qml
import QtQuick

Text {
    id: timeDisplay

    required property string timeInput // input arguement

    text: timeInput
    color: "#ffffff"
    font.pixelSize: 14
    font.family: "Inter, sans-serif"
}