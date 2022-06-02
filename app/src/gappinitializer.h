#ifndef GAPPINITIALIZER_H
#define GAPPINITIALIZER_H

#include "fileio.h"
#include "gappinfo.h"
#include "gappupdater.h"
#include "gutility.h"
#include "nodeprovider.h"
#include "scheduler.h"

#include <QQmlApplicationEngine>

class GAppInitializer
{
public:
    GAppInitializer();
    ~GAppInitializer();

    int init(const QString& starterFile);

    static QQmlApplicationEngine* getEngine();

private:
    static QQmlApplicationEngine* appEngine;

    FileIO* m_fileIO;
    G::Scheduler* m_scheduler;
    NodeProvider* m_nodeProvider;
    GUtility* m_utility;
    GAppInfo* m_appInfo;
    GAppUpdater* m_appUpdater;
};

#endif // GAPPINITIALIZER_H
