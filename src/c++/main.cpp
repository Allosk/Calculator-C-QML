#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "calculated.h"
int main(int argc, char *argv[])
{

    QGuiApplication app(argc, argv);
    qputenv("QT_ASSUME_STDERR_HAS_CONSOLE", "1");

    QQmlApplicationEngine engine;
    qmlRegisterType<Calculated>("Calculator", 1, 0, "Calculated");

    QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
