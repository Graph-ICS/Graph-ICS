#ifndef QTDARKERFILTER_H
#define QTDARKERFILTER_H

#include "node.h"

class QtDarkerFilter : public Node
{
    Q_OBJECT

public:
    explicit QtDarkerFilter();
    virtual ~QtDarkerFilter() {}

    virtual bool retrieveResult();
};

#endif // QTDARKERFILTER_H
