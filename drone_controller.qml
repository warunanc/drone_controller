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
import QtQuick 2.0
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

    function add_waypoint(lat, lng, mouseX, mouseY){
        var item = Qt.createQmlObject('import QtQuick 2.7; import QtLocation 5.3; MapQuickItem{}', map, "dynamic");
        item.coordinate = QtPositioning.coordinate(lat, lng);
        var circle = Qt.createQmlObject('import QtQuick 2.7;Image{
                                                source: "images/circle.png";
                                            }', map);
        item.sourceItem = circle;
        item.anchorPoint.x = circle.width/2;
        item.anchorPoint.y = circle.height/2;

        var id = waypointmanager.add_waypoint(lat, lng, mouseX, mouseY);
        var wayPointNumber = Qt.createQmlObject('import QtQuick.Controls 1.4; Label {
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
        propagateComposedEvents: true

        onClicked: {
            console.log('latitude = '+ (map.toCoordinate(Qt.point(mouse.x,mouse.y)).latitude),
                        'longitude = '+ (map.toCoordinate(Qt.point(mouse.x,mouse.y)).longitude));
            console.log('x: ' + mouse.x + '| y: ' + mouse.y);
            add_waypoint(map.toCoordinate(Qt.point(mouse.x,mouse.y)).latitude,
                         map.toCoordinate(Qt.point(mouse.x,mouse.y)).longitude,
                         mouse.x, mouse.y)
        }
    }

    Button {
        id:simulate_flight_path
        y: 10
        x: 20
        text: "Simulate Flight Path"
        onClicked: buildAnimation()
    }

    Button {
        id: show_route
        x: width+60
        y: 10
        text: "Show Route"
        onClicked: drawRoute()
    }

// Animation
    Image {
        id: drone
        source: "images/drone.png"
    }

    function buildAnimation() {
        var path = [{ x: 182, y: 142 },
                    { x: 165, y: 273 },
                    { x: 509, y: 401 }];

        var animation_code = 'SequentialAnimation {
                                running: true;
                                loops: -1;}';
        var animation = Qt.createQmlObject('import QtQuick 2.7;' + animation_code, mainRect);
        //console.log(animation_code);

        var path_animation_code =  'PathAnimation {
                                    id: pathAnim;
                                    duration: 4000;
                                    easing.type: Easing.Linear;
                                    target: drone;
                                    anchorPoint: Qt.point(drone.width/2, drone.height/2);
                                    path: Path {
                                          startX:' + path[0].x + '; startY: ' + path[0].y + ';' +
                                          getPathElements(path) +
                                    '}
                                  }';

        var path_animation = Qt.createQmlObject('import QtQuick 2.7;' + path_animation_code, animation);
        //console.log(path_animation_code);

        animation.start();
    }

    function getPathElements(path) {
        var pathElementString = "";

        for(var i=1; i < path.length; ++i){
            pathElementString = pathElementString +
                    'PathLine {
                        x: ' + path[i].x + ';' +
                        'y: ' + path[i].y + ';}';
        }

        return pathElementString;
    }

//    SequentialAnimation {
//        running: true
//        loops: -1

//        PathAnimation {
//            id: pathAnim
//            duration: 4000
//            easing.type: Easing.Linear

//            target: drone
//            anchorPoint: Qt.point(drone.width/2, drone.height/2)
//            path: Path {
//                startX: 50; startY: 50

//                PathLine {
//                    x: 182
//                    y: 142
//                }
//                PathLine {
//                    x: 165
//                    y: 273
//                }
//                PathLine {
//                    x: 509
//                    y: 401
//                }
//            }
     //   }
    //}
}
