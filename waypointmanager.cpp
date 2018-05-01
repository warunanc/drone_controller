#include "waypointmanager.h"

WayPointManager::WayPointManager(QObject *parent) :
    QObject(parent)
{

}

int WayPointManager::add_waypoint(QString lat, QString lng, int mouseX, int mouseY)
{
    int wayPointId = _mapWayPoints.count() + 1;

    WayPoint* wayPoint = new WayPoint(lat, lng, wayPointId, mouseX, mouseY);
    _mapWayPoints.insert(wayPointId, wayPoint);
    return wayPointId;
}

QList<QPoint *> WayPointManager::get_waypoints()
{

}
