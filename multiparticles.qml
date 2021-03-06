import QtQuick 2.0
import QtQuick.Particles 2.0
import QtQuick.Window 2.0

Window {
    width: 640; height: 480; color: "black"; visible: true

   MultiPointTouchArea {
        anchors.fill: parent
        minimumTouchPoints: 1; maximumTouchPoints: 5
onTouchUpdated: { for (var i=0;i<touchPoints.length; i++) {
                    var touch = touchPoints[i];
                    console.log("x: " + touch.x + " start x: " + touch.startX + " y: " + touch.y + " start y: " + touch.startY)
                } }
        touchPoints: [
            TouchPoint { id: touch1 },
            TouchPoint { id: touch2 },
            TouchPoint { id: touch3 },
            TouchPoint { id: touch4 },
            TouchPoint { id: touch5 }
        ] }

    ParticleSystem {
        id: psystem
        anchors.fill: parent

        Component { id: particle; ItemParticle {
			id: part
			property string group; groups: [group]
            delegate: Rectangle {
                color: part.group
                width: 3; height: width; radius: width / 2
            } } }

        Component { id: emitter; Emitter {
                property TouchPoint point
                x: point.x; y: point.y; enabled: point.pressed
                emitRate: 500; velocity: PointDirection{ y: -90; yVariation: 150; xVariation: 50}
        } }

        Component.onCompleted: {
            emitter.createObject(psystem, {"point": touch1, "group": "red"});
            particle.createObject(psystem, {"group": "red"});
            emitter.createObject(psystem, {"point": touch2, "group": "yellow"});
            particle.createObject(psystem, {"group": "yellow"});
            emitter.createObject(psystem, {"point": touch3, "group": "green"});
            particle.createObject(psystem, {"group": "green"});
            emitter.createObject(psystem, {"point": touch4, "group": "blue"});
            particle.createObject(psystem, {"group": "blue"});
            emitter.createObject(psystem, {"point": touch5, "group": "violet"});
            particle.createObject(psystem, {"group": "violet"});
        }
    }
}
