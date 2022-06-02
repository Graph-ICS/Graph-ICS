#ifndef QTLIGHTER_H
#define QTLIGHTER_H

#include "node.h"

namespace G
{
class QtLighter : public Node
{
    Q_OBJECT

public:
    explicit QtLighter();
    virtual ~QtLighter()
    {
    }

    virtual bool retrieveResult() override;

private:
    Port m_inPort;
    Port m_outPort;
    Attribute* m_factor;
};
} // namespace G

#endif // QTLIGHTER_H
