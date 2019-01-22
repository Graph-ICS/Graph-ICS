#ifndef IMAGE_H
#define IMAGE_H

#include "node.h"

class Image : public Node
{
    Q_OBJECT
    Q_PROPERTY(QString path READ getPath WRITE setPath NOTIFY pathChanged)

public:
    explicit Image();

    QString getPath() { return m_path; }
    void setPath(const QString& path);

    bool retrieveResult();

    void cleanCache();

signals:
    void pathChanged();

private:
    QString m_path;
};

#endif // IMAGE_H
