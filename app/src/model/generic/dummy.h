#ifndef GDUMMY_H
#define GDUMMY_H

#include "node.h"

namespace G
{
class Dummy : public Node
{
public:
    Dummy();

    bool retrieveResult() override;

private:
    Port m_inPort;
    Port m_outPort;
};
} // namespace G

#endif // GDUMMY_H
