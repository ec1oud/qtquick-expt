import QtQuick 2.4

Rectangle {
    width: 640
    height: 480
    Flickable {
        id: flick
        anchors.fill: parent
        anchors.margins: 6
        contentWidth: text.implicitWidth
        contentHeight: text.implicitHeight
        Text {
            id: text
            text: "foo bar"
        }
    }

    Timer { id: fadeTimer; interval: 1000; onTriggered: { hfade.start(); vfade.start() } }

    Rectangle {
        id: verticalScrollDecorator
        anchors.right: parent.right
        anchors.margins: 2
        color: "cyan"
        border.color: "black"
        border.width: 1
        width: 5
        radius: 2
        antialiasing: true
        height: flick.height * (flick.height / flick.contentHeight) - (width - anchors.margins) * 2
        y:  flick.contentY * (flick.height / flick.contentHeight)
        NumberAnimation on opacity { id: vfade; to: 0; duration: 500 }
        onYChanged: { opacity = 1.0; fadeTimer.restart() }
    }

    Rectangle {
        id: horizontalScrollDecorator
        anchors.bottom: parent.bottom
        anchors.margins: 2
        color: "cyan"
        border.color: "black"
        border.width: 1
        height: 5
        radius: 2
        antialiasing: true
        width: flick.width * (flick.width / flick.contentWidth) - (height - anchors.margins) * 2
        x:  flick.contentX * (flick.width / flick.contentWidth)
        NumberAnimation on opacity { id: hfade; to: 0; duration: 500 }
        onXChanged: { opacity = 1.0; fadeTimer.restart() }
    }

    // http://rschroll.github.io/beru/2013/08/12/opening-a-file-in-qml.html
    Component.onCompleted: {
        var request = new XMLHttpRequest()
        request.open('GET', 'test.txt')
        request.onreadystatechange = function(event) {
            if (request.readyState === XMLHttpRequest.DONE)
                text.text = request.responseText
        }
        request.send()
    }
}
