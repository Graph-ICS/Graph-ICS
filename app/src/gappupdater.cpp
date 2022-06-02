#include "gappupdater.h"

#include <QApplication>
#include <QProcess>
#include <QString>
#include <QStringList>

#include <QDebug>

GAppUpdater::GAppUpdater()
    : m_updateAvailable(false)
    #ifdef _WIN32
    , m_maintencancetool(QCoreApplication::applicationDirPath() + "/maintenancetool")
    #elif __APPLE__
    , m_maintencancetool(QCoreApplication::applicationDirPath() + "/../../../maintenancetool.app/Contents/MacOS/maintenancetool")
    #elif __linux__
    , m_maintencancetool(QCoreApplication::applicationDirPath() + "/maintenancetool")
    #endif
{
}

GAppUpdater::~GAppUpdater()
{
    wait();
}

void GAppUpdater::checkForUpdates()
{
    if (!isRunning())
    {
        start();
    }
}

void GAppUpdater::startUpdateTool()
{
    QProcess::startDetached(m_maintencancetool, {"--updater"});
}

void GAppUpdater::run()
{
    if (!m_updateAvailable)
    {
        QProcess checkUpdates;
        checkUpdates.start(m_maintencancetool, {"--checkupdates"});

        checkUpdates.waitForFinished();

        if (checkUpdates.error() != QProcess::UnknownError)
        {
            qDebug() << "GAppUpdater: " + m_maintencancetool+ " not found!";
        }
        else
        {
            QByteArray data = checkUpdates.readAllStandardOutput();

            QString output(data);

            if (output.contains("no updates") || output.contains("Network error"))
            {
                qDebug() << "GAppUpdater: No updates available!";
            }
            else
            {
                qDebug() << "GAppUpdater: Updates available!";
                m_updateAvailable = true;
            }
        }
    }

    emit checkForUpdatesFinished(m_updateAvailable);
}
