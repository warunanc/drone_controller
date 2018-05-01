#include "waypoint.h"

WayPoint::WayPoint(QString x, QString y, int id, QPoint mousePoint, QObject *parent) :
    QObject(parent),
    _x(x),
    _y(y),
    _id(id),
    _mousePoint(mousePoint)
{

}
