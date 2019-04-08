#ifndef QTDARKERFILTER_H
#define QTDARKERFILTER_H

#include "node.h"

class QtDarkerFilter : public Node
{
    Q_OBJECT
    Q_PROPERTY(double value READ getValue WRITE setValue NOTIFY valueChanged)

public:
    explicit QtDarkerFilter();
    virtual ~QtDarkerFilter() {}

    double getValue() { return m_factor; }
    void setValue(const double value);

    virtual bool retrieveResult();

signals:
    void valueChanged();

private:
    double m_factor;
};

#endif // QTDARKERFILTER_H
