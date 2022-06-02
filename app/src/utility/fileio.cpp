#include "fileio.h"

#include <QImageWriter>

#include <QDir>
#include <QFile>
#include <QStandardPaths>
#include <QTextStream>

FileIO::FileIO(QObject* parent)
    : QObject(parent)
{
}

QString FileIO::openTextFile(QString path)
{
    QString res = "";
    path = removePathoverhead(path);
    QFile file(path);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        return res;
    }
    QTextStream in(&file);
    while (!in.atEnd())
    {
        res += in.readLine();
        res += "\n";
    }
    return res;
}

void FileIO::saveTextFile(const QString& text, QString path)
{
    path = removePathoverhead(path);
    int index = path.lastIndexOf("/");
    if (index != -1)
    {
        QString dirPath = path.left(index);
        QDir dir;
        if (!dir.exists(dirPath))
        {
            dir.mkpath(dirPath);
        }
    }
    QFile file(path);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
    {
        return;
    }
    QTextStream out(&file);
    out << text;
}

QString FileIO::removePathoverhead(QString path)
{
    if (path.startsWith("file"))
    {
        path.remove(0, PATHOVERHEAD);
    }
    if (path.endsWith("\xd\xa\0"))
    {
        path.remove(path.length() - 2, path.length());
        qDebug() << "FileIO::removePathoverhead: Removed linux string ending!";
    }
    return path;
}

bool FileIO::isFileExisting(QString path)
{
    path = removePathoverhead(path);
    return QFile::exists(path);
}

bool FileIO::deleteFile(QString path)
{
    path = removePathoverhead(path);
    return QFile::remove(path);
}

QString FileIO::getAppDataDir()
{
    return QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
}
