#ifndef QTBLACKWHITE_H
#define QTBLACKWHITE_H

#include "node.h"

namespace G
{
class QtBlackWhite : public Node
{
    Q_OBJECT

public:
    explicit QtBlackWhite();
    virtual ~QtBlackWhite()
    {
    }

    virtual bool retrieveResult();

private:
    Port m_inPort;
    Port m_outPort;
};
} // namespace G

#endif // QTBLACKWHITE_H
