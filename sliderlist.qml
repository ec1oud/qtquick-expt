import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1

Rectangle {
    id: root
    width: 500
    height: 300
    ListView {
        id: list
        anchors.fill: parent
        anchors.margins: 10
        orientation: Qt.Horizontal
        spacing: 10

        model: 10

        delegate:  Slider {
            orientation: Qt.Vertical
            width: Screen.pixelDensity * 20
            height: list.height
            //~ enabled: false
            activeFocusOnPress: true
        }
    }
}
