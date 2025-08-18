// Bar.qml
import Quickshell

Scope {
  // the Time type we just created
  Time { id: timeSource }

  Variants {
    model: Quickshell.screens

    PanelWindow {
        required property var modelData
        screen: modelData

        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: 20
        
        ClockWidget {
            anchors.centerIn: parent
            // now using the time from timeSource
            time: timeSource.time
        }
    }
  }
}