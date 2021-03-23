#ifndef GDATA_H
#define GDATA_H

#include <QList>
#include <QVariant>

class GData
{
public:
    GData();
    bool isEmpty();
    void clear();

    void append(QVariant data);
    void setData(QList<QVariant> list);

    const QList<QVariant>& getData();
    GData deepCopy();

private:
    QList<QVariant> m_1D;

};

#endif // GDATA_H
