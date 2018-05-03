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
    virtual ~WayPointManager();
    Q_INVOKABLE int addWayPoint(QString x, QString y, QPoint mousePoint);
    Q_INVOKABLE int count();
    Q_INVOKABLE QPoint getWayPointById(int index);
    Q_INVOKABLE void clearAll();

private:
    QMap<int, WayPoint*> _mapWayPoints;
};

#endif // WAYPOINTMANAGER_H
