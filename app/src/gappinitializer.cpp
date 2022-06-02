#include "gappinitializer.h"

#include "cameratask.h"
#include "imagetask.h"
#include "videotask.h"

#include "node.h"

#include <QQmlContext>
#include <QQmlProperty>

#if REMOTE_PLUGIN_ENABLED
#include "commthread.h"
#endif

QQmlApplicationEngine* GAppInitializer::appEngine = nullptr;

GAppInitializer::GAppInitializer()
    : m_fileIO(new FileIO())
    , m_scheduler(new G::Scheduler())
    , m_nodeProvider(new NodeProvider())
    , m_utility(new GUtility())
    , m_appInfo(new GAppInfo())
    , m_appUpdater(new GAppUpdater())
{
}

GAppInitializer::~GAppInitializer()
{
    delete m_fileIO;
    delete m_scheduler;
    delete m_nodeProvider;
    delete m_utility;
    delete m_appInfo;
    delete m_appUpdater;

    delete appEngine;
}

int GAppInitializer::init(const QString& starterFile)
{
    m_nodeProvider->registerNodes();

    qmlRegisterSingletonType(QUrl("qrc:/Theme.qml"), "Theme", 1, 0, "Theme");
    qmlRegisterSingletonType(QUrl("qrc:/Global.qml"), "Global", 1, 0, "Global");

    qmlRegisterUncreatableType<G::Node>("Backend", 1, 0, "Node", "Error: only enums");
    qmlRegisterUncreatableType<G::Port>("Backend", 1, 0, "Port", "Error: only enums");
    qmlRegisterUncreatableType<G::Attribute>("Backend", 1, 0, "Attribute", "Error: only enums");

    qmlRegisterType<G::ImageTask>("Backend", 1, 0, "ImageTask");
    qmlRegisterType<G::VideoTask>("Backend", 1, 0, "VideoTask");
    qmlRegisterType<G::CameraTask>("Backend", 1, 0, "CameraTask");

    qRegisterMetaType<G::Node*>("Node");
    qRegisterMetaType<G::Attribute*>("Attribute");
    qRegisterMetaType<G::Task*>("Task");

    appEngine = new QQmlApplicationEngine();

    appEngine->rootContext()->setContextProperty("scheduler", m_scheduler);
    appEngine->rootContext()->setContextProperty("fileIO", m_fileIO);
    appEngine->rootContext()->setContextProperty("utility", m_utility);
    appEngine->rootContext()->setContextProperty("appInfo", m_appInfo);
    appEngine->rootContext()->setContextProperty("nodeProvider", m_nodeProvider);
    //    appEngine->rootContext()->setContextProperty("appUpdater", m_appUpdater);

#if REMOTE_PLUGIN_ENABLED
    appEngine->rootContext()->setContextProperty("commThread", &CommThread::getInstance());
    qRegisterMetaType<boost::shared_ptr<Entities::Request>>("boost::shared_ptr<Entities::Request>");
#endif

    // load the main.qml into the engine
    appEngine->load(QUrl(starterFile));

    // error handling
    if (appEngine->rootObjects().isEmpty())
    {
        return -1;
    }

    return 0;
}

QQmlApplicationEngine* GAppInitializer::getEngine()
{
    return appEngine;
}
