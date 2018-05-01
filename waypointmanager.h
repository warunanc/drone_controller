#ifndef WAYPOINTMANAGER_H
#define WAYPOINTMANAGER_H

#include <QObject>
#include <QMap>
#include <QList>
#include <QPoint>
#include "waypoint.h"

class WayPointManager : public QObject
{
    Q_OBJECT
public:
    explicit WayPointManager(QObject *parent = nullptr);
    Q_INVOKABLE int add_waypoint(QString x, QString y, int mouseX, int mouseY);
    Q_INVOKABLE QList<QPoint*> get_waypoints();

private:
    QMap<int, WayPoint*> _mapWayPoints;
};

#endif // WAYPOINTMANAGER_H
