TARGET = drone_controller
TEMPLATE = app

QT += quick qml network positioning location
SOURCES = main.cpp \
    waypointmanager.cpp \
    waypoint.cpp

RESOURCES += \
    drone_controller.qrc

target.path = ../drone_controller_build
INSTALLS += target

HEADERS += \
    waypointmanager.h \
    waypoint.h

