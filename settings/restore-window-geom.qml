import QtQuick.Window 2.1
import Qt.labs.settings 1.0

Window {
    id: window

    width: 800
    height: 600
    visible: true

    property Settings settings: Settings {
        property alias x: window.x
        property alias y: window.y
        property alias width: window.width
        property alias height: window.height
    }
}
