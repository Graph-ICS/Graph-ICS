#ifndef QTLIGHTERFILTER_H
#define QTLIGHTERFILTER_H

#include "node.h"

class QtLighterFilter : public Node
{
    Q_OBJECT

public:
    explicit QtLighterFilter();
    virtual ~QtLighterFilter() {}

    virtual bool retrieveResult();
};

#endif // QTLIGHTERFILTER_H
