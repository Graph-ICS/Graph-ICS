#ifndef FILEIO_H
#define FILEIO_H

#include <QFile>
#include <QObject>

#ifdef _WIN32
#define PATHOVERHEAD 8
#elif __APPLE__
#define PATHOVERHEAD 7
#elif __linux__
#define PATHOVERHEAD 7
#endif

class FileIO : public QObject
{
    Q_OBJECT
public:
    FileIO(QObject* parent = nullptr);

    Q_INVOKABLE static QString removePathoverhead(QString path);

    Q_INVOKABLE static QString openTextFile(QString path);
    Q_INVOKABLE static void saveTextFile(const QString& fileContent, QString path);

    Q_INVOKABLE static bool isFileExisting(QString path);
    Q_INVOKABLE static bool deleteFile(QString path);

    Q_INVOKABLE static QString getAppDataDir();
};

#endif // FILEIO_H
