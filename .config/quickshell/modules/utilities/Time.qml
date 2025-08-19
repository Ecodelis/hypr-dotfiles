// Time.qml

import Quickshell
import Quickshell.Io
import QtQuick

Scope {
    id: root
    property string currentTime: "No Time"

    function updateTime() {
        var presentTime = new Date();

        currentTime = Qt.formatDateTime(presentTime, "yyyy MMM dd") +  " " +
                      Qt.formatDateTime(presentTime, "hh:mm:ss")
                      //+ (presentTime.getHours() >= 12 ? " PM" : " AM");
    }

    // Update time every second
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: updateTime()
    }

    // Initialize time immediately
    Component.onCompleted: updateTime()
}




