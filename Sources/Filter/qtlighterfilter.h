#ifndef QTLIGHTERFILTER_H
#define QTLIGHTERFILTER_H

#include "node.h"

class QtLighterFilter : public Node
{
    Q_OBJECT
    Q_PROPERTY(double factor READ getFactor WRITE setFactor NOTIFY factorChanged)

public:
    explicit QtLighterFilter();
    virtual ~QtLighterFilter() {}

    double getFactor();
    void setFactor(const double value);

    virtual bool retrieveResult();

signals:
    void factorChanged();

private:
    double m_factor;
};

#endif // QTLIGHTERFILTER_H
