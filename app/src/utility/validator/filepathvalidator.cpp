#include "filepathvalidator.h"

#include "fileio.h"

FilePathValidator::FilePathValidator(QList<QString> acceptedFiles)
    : m_acceptedFiles(acceptedFiles)
{
}

QVariant FilePathValidator::validate(const QVariant& value)
{
    QString filePath = value.toString();
    if (filePath.isEmpty())
    {
        return QVariant("");
    }

    filePath = FileIO::removePathoverhead(filePath);
    bool ok = false;
    for (auto& file : m_acceptedFiles)
    {
        if (filePath.endsWith(file))
        {
            ok = true;
        }
    }

    if (!ok)
    {
        qDebug() << "FilePathValidator::validate: File not accepted!";
        return QVariant("");
    }

    return QVariant(filePath);
}
