#ifndef QTLIGHTERFILTER_H
#define QTLIGHTERFILTER_H

#include "node.h"

class QtLighterFilter : public Node
{
    Q_OBJECT
    Q_PROPERTY(double value READ getValue WRITE setValue NOTIFY valueChanged)

public:
    explicit QtLighterFilter();
    virtual ~QtLighterFilter() {}

    double getValue() { return m_factor; }
    void setValue(const double value);

    virtual bool retrieveResult();

signals:
    void valueChanged();

private:
    double m_factor;
};

#endif // QTLIGHTERFILTER_H
