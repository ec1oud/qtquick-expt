import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Window 2.12
import Qt.labs.folderlistmodel 2.12
import Qt.labs.handlers 1.0

Window {
    id: root
    visible: true
    width: 1024; height: 600
    color: "#222222"
    property int highestZ: 0
    property real defaultSize: 64
    property real defaultSpacing: 8
    property real defaultLabelHeight: 20
    property real defaultTileGrid: defaultSize + defaultSpacing

    Rectangle {
        id: toolbar
        width: root.width
        height: currentFolderField.height + 6
        z: 1
        TextField {
            id: currentFolderField
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: 3
            text: folderModel.folder
            onAccepted: folderModel.folder = text
            DropArea {
                anchors.fill: parent
                onDropped: {
                    if (drop.urls.length > 0)
                        folderModel.folder = drop.urls[0] + "/"
                    else
                        currentFolderField.text = drop.text
                }
            }
        }
    }

    Item {
        id: iconArea
        anchors.fill: parent
        anchors.topMargin: toolbar.height

        DropArea {
            id: dragTarget
            anchors.fill: parent
            property var lastUrls: []
            onDropped: {
                console.log("source " + drop.source + " dropped text:" + drop.text + " keys:" + drop.keys + " formats:" + drop.formats + " len " + drop.formats.length)
                if (drop.urls.length > 0)
                    console.log("dropped URLs " + drop.urls + " or " + JSON.stringify(drop.urls))
                for (var i = 0; i < drop.formats.length; ++i) {
                    var fmt = drop.formats[i]
                    console.log(i + ": " + fmt + " = '", drop.getDataAsString(fmt) + "' or " + drop.getDataAsArrayBuffer(fmt))
                }
            }

            states: [
                State {
                    when: dragTarget.containsDrag
                    PropertyChanges {
                        target: root
                        color: "grey"
                    }
                }
            ]
        }

        Repeater {
            model: FolderListModel {
                id: folderModel
                objectName: "folderModel"
                folder: "file:///home/rutledge/art/"
                nameFilters: ["*.png", "*.jpg", "*.gif"]
            }
            Rectangle {
                id: fileFrame
                objectName: fileName
                color: "transparent"
                width: defaultSize
                height: width + defaultLabelHeight
                border.color: root.color
                border.width: 2

                Drag.mimeData: { "text/plain" : folderModel.folder + fileName, "text/uri-list" : folderModel.folder + fileName }
                Drag.active: dh.active
                Drag.dragType: Drag.Automatic
                Drag.proposedAction: dh.centroid !== undefined && dh.centroid.modifiers & Qt.ControlModifier ? Qt.CopyAction :
                                     dh.centroid !== undefined && dh.centroid.modifiers & Qt.AltModifier ? Qt.LinkAction : Qt.MoveAction

                Component.onCompleted: {
                    x = (index * defaultTileGrid) % (Math.floor(root.width / defaultTileGrid) * defaultTileGrid)
                    y = Math.floor((index * defaultTileGrid) / root.width) * (defaultTileGrid + defaultLabelHeight)
                }

                state: Drag.active ? "dragging" : hh.hovered ? "hovered" : ""
                states: [
                    State {
                        name: "hovered"
                        PropertyChanges { target: fileFrame; border.color: "red" }
                    },
                    State {
                        name: "dragging"
                        PropertyChanges { target: fileFrame; border.color: "blue" }
                    }
                ]
                Image {
                    id: image
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: (defaultLabelHeight / -2) + 1
                    fillMode: Image.PreserveAspectFit
                    source: fileIsDir ? "resources/folder.png" : folderModel.folder + fileName
                    scale: defaultSize / Math.max(sourceSize.width, sourceSize.height)
                    antialiasing: true
                }
                Text {
                    color: "white"
                    anchors {
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                    }
                    style: Text.Outline
                    text: fileName
                    wrapMode: Text.Wrap
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: 6
                }

                PinchHandler {
                    enabled: !fileIsDir
                    minimumScale: 0.1
                    maximumScale: 10
                }

                HoverHandler {
                    id: hh
                }

                TapHandler {
                    onPressedChanged: if (pressed) fileFrame.z = ++root.highestZ
                    onDoubleTapped: {
                        if (fileIsDir) {
                            folderModel.folder += fileName + "/"
                        } else {
                            fileFrame.scale = 1
                            var path = folderModel.folder + fileName
                            console.log("opening " + path)
                            Qt.openUrlExternally(path)
                        }
                    }
                }

                DragHandler {
                    id: dh
                    onActiveChanged: if (active) console.log("dragging " + JSON.stringify(fileFrame.Drag.mimeData) + " supported actions " + fileFrame.Drag.supportedActions + " proposed " + fileFrame.Drag.proposedAction)
                    // TODO it's silly that the icon never gets moved because DnD begins as soon as the drag threshold is exceeded; so why do we need DragHandler?
//                    onCentroidChanged: {
//                        if (centroid.modifiers & Qt.ControlModifier)
//                            fileFrame.Drag.proposedAction = Qt.CopyAction
//                        else if (centroid.modifiers & Qt.AltModifier)
//                            fileFrame.Drag.proposedAction = Qt.LinkAction
//                        else
//                            fileFrame.Drag.proposedAction = Qt.MoveAction
//                    }
                }
            }
        }
    }

    Shortcut { sequence: StandardKey.Quit; onActivated: Qt.quit() }
}
