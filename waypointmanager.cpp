#include "waypointmanager.h"

WayPointManager::WayPointManager(QObject *parent) :
    QObject(parent)
{

}

WayPointManager::~WayPointManager()
{
    qDeleteAll(_mapWayPoints);
    _mapWayPoints.clear();
}

int WayPointManager::addWayPoint(QString lat, QString lng, QPoint mousePoint)
{
    int wayPointId = _mapWayPoints.count() + 1;

    WayPoint* wayPoint = new WayPoint(lat, lng, wayPointId, mousePoint);
    _mapWayPoints.insert(wayPointId, wayPoint);
    return wayPointId;
}

int WayPointManager::count()
{
    return _mapWayPoints.size();
}

QPoint WayPointManager::getWayPointById(int index)
{
    return _mapWayPoints.value(index)->getMousePoint();
}

void WayPointManager::clearAll()
{
    qDeleteAll(_mapWayPoints);
    _mapWayPoints.clear();
}
