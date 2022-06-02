#include <QApplication>
#include <QDebug>
#include <QGuiApplication>
#include <QIcon>
#include <QtWebEngine>

#include "gappinitializer.h"

int main(int argc, char* argv[])
{
    QtWebEngine::initialize();

#ifdef _WIN32
    int argcWin = 3;
    char* argvWin[] = {(char*)"Graph-ICS", (char*)"--platform", (char*)"windows:dpiawareness=0"};
    QApplication app(argcWin, argvWin);
#elif __APPLE__
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    qputenv("Q_AUTO_SCREEN_SCALE_FACTOR", "1");
    QApplication app(argc, argv);
    app.setAttribute(Qt::AA_UseHighDpiPixmaps);
#elif __linux__
    QApplication app(argc, argv);
#endif

    app.setApplicationName("Graph-ICS");
    app.setOrganizationName("Continental Engineering Services GmbH");
    app.setOrganizationDomain("https://github.com/Graph-ICS/Graph-ICS");

    // set the program icon
#ifdef __linux__
    app.setWindowIcon(QIcon(":/logo_64px.png"));
#else
    app.setWindowIcon(QIcon(":/logo.png"));
#endif

    GAppInitializer initializer;
    if (initializer.init("qrc:/Main.qml") == -1)
    {
        qDebug() << "Initialization failed!";
        return -1;
    }

    // start the QApplication
    return app.exec();
}
