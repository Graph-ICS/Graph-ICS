#ifndef QTBLACKWHITEFILTER_H
#define QTBLACKWHITEFILTER_H

#include "node.h"

class QtBlackWhiteFilter : public Node
{
    Q_OBJECT

public:
    explicit QtBlackWhiteFilter();

    bool retrieveResult();
};

#endif // QTBLACKWHITEFILTER_H

