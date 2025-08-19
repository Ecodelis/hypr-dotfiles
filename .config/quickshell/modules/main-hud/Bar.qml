import QtQuick
import Quickshell
import Quickshell.Hyprland

// Bar placement space
PanelWindow {
    id: root
    color: "transparent"
    HyprlandWindow.opacity: 0.9

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 40
    
    // margin from screen edges
    margins {
        top: 4
        left: 10
        right: 10
    }

    // The actual bar
    Rectangle {
        id: bar

        anchors.fill: parent
        color: "#1A1A1A"
        radius: 15
        border.color: "#333333"
        border.width: 5

        Row {
            id: workspacesRow

            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: 16
            }

            spacing: 8

            Repeater {
                model: Hyprland.workspaces

                Rectangle {
                    width: 32
                    height: 24
                    radius: 4
                    color: modelData.active ? "#4a9eff" : "#333333"
                    border.color: "#555555"
                    border.width: 2

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Hyprland.dispatch("workspace " + modelData.id) // also typo here: it's `workspace`, not `workspaces`
                    }

                    Text {
                        text: modelData.id
                        anchors.centerIn: parent
                        color: modelData.active ? "#ffffff" : "#cccccc"
                        font.pixelSize: 12
                        font.family: "Inter, sans-serif"
                    }
                }
            }

            Text {
                visible: Hyprland.workspaces.length === 0  // typo fixed: was `visable`
                text: "No workspaces"
                color: "#ffffff"
                font.pixelSize: 12
                font.family: "Inter, sans-serif"
            }
        }

        Time { id: timeSource } // Auto updating time object
        ClockWidget {
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: 16
            }

            // Get current time and assign it timeInput argument
            timeInput: timeSource.currentTime

        }
    }
}