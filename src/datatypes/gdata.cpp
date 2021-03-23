#include "gdata.h"

GData::GData()
{

}

bool GData::isEmpty()
{
    return m_1D.isEmpty();
}

void GData::clear()
{
    m_1D.clear();
}

void GData::append(QVariant data)
{
    m_1D.append(data);
}

void GData::setData(QList<QVariant> list)
{
    m_1D = list;
}

const QList<QVariant> &GData::getData()
{
    return m_1D;
}

GData GData::deepCopy()
{
    return *this;
}
