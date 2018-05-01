#ifndef WAYPOINT_H
#define WAYPOINT_H

#include <QObject>
#include <QPoint>

class WayPoint : public QObject
{
    Q_OBJECT
public:
    explicit WayPoint(QString x, QString y, int id, QPoint mousePoint, QObject *parent = nullptr);
    QPoint getMousePoint() { return _mousePoint; };

private :
    QString _x = "";
    QString _y = "";
    int _id = -1;
    QPoint _mousePoint;
};

#endif // WAYPOINT_H
