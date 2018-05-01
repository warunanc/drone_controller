#include "waypoint.h"

WayPoint::WayPoint(QString x, QString y, int id, int mouseX, int mouseY, QObject *parent) :
    QObject(parent),
    _x(x),
    _y(y),
    _id(id),
    _mouseX(mouseX),
    _mouseY(mouseY)
{

}
