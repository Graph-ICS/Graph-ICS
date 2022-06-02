#ifndef GAPPUPDATER_H
#define GAPPUPDATER_H

#include <QObject>
#include <QThread>

class GAppUpdater : public QThread
{
    Q_OBJECT

public:
    GAppUpdater();
    ~GAppUpdater();

    Q_INVOKABLE void checkForUpdates();
    Q_INVOKABLE void startUpdateTool();

signals:
    void checkForUpdatesFinished(bool updateAvailable);

protected:
    void run() override;

private:
    bool m_updateAvailable;
    QString m_maintencancetool;
};

#endif // GAPPUPDATER_H
