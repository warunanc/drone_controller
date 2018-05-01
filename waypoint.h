#ifndef WAYPOINT_H
#define WAYPOINT_H

#include <QObject>

class WayPoint : public QObject
{
    Q_OBJECT
public:
    explicit WayPoint(QString x, QString y, int id, int mouseX, int mouseY,QObject *parent = nullptr);

private :
    QString _x = "";
    QString _y = "";
    int _mouseX = 0;
    int _mouseY = 0;
    int _id = -1;
};

#endif // WAYPOINT_H
