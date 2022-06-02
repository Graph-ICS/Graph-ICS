#ifndef QTDARKER_H
#define QTDARKER_H

#include "node.h"

namespace G
{
class QtDarker : public Node
{
    Q_OBJECT

public:
    explicit QtDarker();
    virtual ~QtDarker()
    {
    }

    virtual bool retrieveResult();

private:
    Port m_inPort;
    Port m_outPort;

    Attribute* m_factor;
};
} // namespace G
#endif // QTDARKER_H
