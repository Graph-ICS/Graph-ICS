#ifndef QTDARKERFILTER_H
#define QTDARKERFILTER_H

#include "node.h"

class QtDarkerFilter : public Node
{
    Q_OBJECT
    Q_PROPERTY(double factor READ getFactor WRITE setFactor NOTIFY factorChanged)

public:
    explicit QtDarkerFilter();
    virtual ~QtDarkerFilter() {}

    double getFactor();
    void setFactor(const double value);

    virtual bool retrieveResult();

signals:
    void factorChanged();

private:
    double m_factor;
};

#endif // QTDARKERFILTER_H
