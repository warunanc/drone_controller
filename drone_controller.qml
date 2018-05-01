/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

//! [Imports]
import QtQuick 2.7
import QtPositioning 5.5
import QtLocation 5.6
import QtQuick.Controls 1.4
import QtQuick.Extras 1.4
import QtQuick.Controls.Styles 1.4
import com.waypoint 1.0
//! [Imports]

Rectangle {
    id: mainRect
    anchors.fill: parent

    WayPointManager {
        id: waypointmanager
    }

    Rectangle {
            height: 55
            x: 10
            y: 5
            z: 2
            enabled: true
            width: 170;
            color: "white"
            opacity: 0.8
            border.color: "black";
            border.width: 2;

            Column {
                spacing: 8
                y: 2

                Row {
                    spacing: 2;
                    leftPadding: 5
                    Button {
                        id:simulate_flight_path
                        y: 5
                        x: 5
                        text: "Start Flying.."
                        enabled: true
                        onClicked: buildDroneAnimation()
                    }

                    Button {
                        id:clear_stuff
                        y: 5
                        x: 5
                        text: "Clear Waypoints"
                        enabled: true
                        onClicked: _clearAll()
                    }
                }

                CheckBox {
                    id: check_comback
                    x: 5
                    text: "Come back on the same path"
                    checked: false
                }
            }
        }

    // Longitude Stuff
    Label {
        visible: false
        id: long_label
        height: 30
        y: 70
        x: 15
        z: 3
        text: "Longitude"
        enabled: true
        width: 170;
        color: "black"
        font.pixelSize: 16;
        font.italic: false;
        font.bold: true;
        antialiasing: true
    }

    Label {
        id: long_val
        visible: false
        height: 30
        y: 90
        x: 15
        z: 3
        text: "xxx.xxxxxx"
        enabled: true
        width: 170;
        color: "blue"
        font.pixelSize: 14;
        font.italic: false;
        font.bold: true;
        antialiasing: true
    }

    Rectangle {
        id: long_rec
        visible: false
        height: 50
        x: 10
        y: 65
        z: 2
        enabled: true
        width: 170;
        color: "white"
        opacity: 0.8
        border.color: "blue";
        border.width: 2;
    }
    // Longitude Stuff

    // Latitude Stuff
    Label {
        id: lat_label
        visible: false
        height: 30
        y: 130
        x: 15
        z: 3
        text: "Latitude"
        enabled: true
        width: 170;
        color: "black"
        font.pixelSize: 16;
        font.italic: false;
        font.bold: true;
        antialiasing: true
    }

    Label {
        id: lat_val
        visible: false
        height: 30
        y: 150
        x: 15
        z: 3
        text: "xxx.xxxxxx"
        enabled: true
        width: 170;
        color: "green"
        font.pixelSize: 14;
        font.italic: false;
        font.bold: true;
        antialiasing: true
    }

    Rectangle {
        id: lat_rec
        visible: false
        height: 50
        x: 10
        y: 125
        z: 2
        enabled: true
        width: 170;
        color: "white"
        opacity: 0.8
        border.color: "green";
        border.width: 2;
    }
    //Latitude Stuff

    Plugin {
        id: myPlugin
        name: "osm"
    }

    property variant locationChangiAirport: QtPositioning.coordinate( 1.359395, 103.989553)

    PositionSource {
        id: positionSource
        property variant lastSearchPosition: locationChangiAirport
        active: true
        updateInterval: 120000 // 2 mins
        onPositionChanged:  {
            var currentPosition = positionSource.position.coordinate
            map.center = currentPosition
            var distance = currentPosition.distanceTo(lastSearchPosition)
            if (distance > 500) {
                lastSearchPosition = currentPosition
                searchModel.searchArea = QtPositioning.circle(currentPosition)
                searchModel.update()
            }
        }
    }

    Map {
        id: map
        anchors.fill: parent
        plugin: myPlugin;
        center: locationChangiAirport
        zoomLevel: 15
    }

    function _clearAll() {
        map.clearMapItems();
        waypointmanager.clearAll();
        drone.visible = false;
    }

    function _addWaypoint(lat, lng, mousePoint){
        var item = Qt.createQmlObject('import QtQuick 2.7; import QtLocation 5.3; MapQuickItem{}', map, "dynamic");
        item.coordinate = QtPositioning.coordinate(lat, lng);
        var circle = Qt.createQmlObject('import QtQuick 2.7;Image{
                                                source: "images/circle.png";
                                            }', map);
        item.sourceItem = circle;
        item.anchorPoint.x = circle.width/2;
        item.anchorPoint.y = circle.height/2;

        var id = waypointmanager.addWayPoint(lat, lng, mousePoint);
        var wayPointNumber = Qt.createQmlObject
                ('import QtQuick.Controls 1.4; Label {
                                text: "'+id+'";
                                font.pixelSize: 25;
                                font.italic: false;
                                font.bold: true;
                                color: "white";
                                anchors.centerIn: parent
                            }', circle);

        map.addMapItem(item);
    }

    function drawRoute() {

    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log('latitude = '+ (map.toCoordinate(Qt.point(mouse.x,mouse.y)).latitude),
                        'longitude = '+ (map.toCoordinate(Qt.point(mouse.x,mouse.y)).longitude));
            console.log('x: ' + mouse.x + '| y: ' + mouse.y);
            _addWaypoint(map.toCoordinate(Qt.point(mouse.x,mouse.y)).latitude,
                         map.toCoordinate(Qt.point(mouse.x,mouse.y)).longitude,
                         Qt.point(mouse.x,mouse.y))
        }
    }

    Image {
        id: drone
        visible: false;
        source: "images/drone.png"
        onXChanged: {
            console.log("lat: ", map.toCoordinate(Qt.point(this.x,this.y)).latitude);
            console.log("long: ", map.toCoordinate(Qt.point(this.x,this.y)).longitude);
            long_val.text = map.toCoordinate(Qt.point(this.x,this.y)).longitude;
            lat_val.text = map.toCoordinate(Qt.point(this.x,this.y)).latitude;
        }
    }

    function buildDroneAnimation() {
        if (waypointmanager.count() > 1) {
            drone.visible = true;
            _longLatBoxVisibility(true);
            var pathAnimationObject = Qt.createQmlObject('import QtQuick 2.7;' + 'Path {
                startX: ' + waypointmanager.getWayPointById(1).x + '; startY: ' + waypointmanager.getWayPointById(1).y + ';' +
                                                         getPathElements() +
                                                         '}', mainRect);

            pathAnim.path = pathAnimationObject;
            animation_test.restart();
        }
        else {
            drone.visible = false;
        }
    }

    function getPathElements() {
        var pathElementString = "";

        for (var i=2; i < waypointmanager.count()+1; ++i) {
            pathElementString = pathElementString +
                    'PathLine {
                     x: ' + waypointmanager.getWayPointById(i).x + ';' +
                     'y: ' + waypointmanager.getWayPointById(i).y + ';
                }';
        }
        return pathElementString;
    }

    function _longLatBoxVisibility(visibility) {
        long_label.visible = visibility;
        long_rec.visible = visibility;
        long_val.visible = visibility;

        lat_label.visible = visibility;
        lat_rec.visible = visibility;
        lat_val.visible = visibility;
    }

    SequentialAnimation {
        id: animation_test
        running: false
        loops: 1
        onStopped: _longLatBoxVisibility(false)

        PathAnimation {
            id: pathAnim
            duration: 4000
            easing.type: check_comback.checked? Easing.SineCurve : Easing.Linear
            target: drone
            anchorPoint: Qt.point(drone.width/2, drone.height/2)
        }
    }
}
