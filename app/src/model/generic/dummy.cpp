#include "dummy.h"

namespace G
{

Dummy::Dummy()
    : Node("Dummy")
    , m_inPort(Port::TYPE::GIMAGE)
    , m_outPort(Port::TYPE::GIMAGE)
{
    registerPorts({&m_inPort}, {&m_outPort});
}

bool Dummy::retrieveResult()
{
    m_outPort.setGImage(m_inPort.getGImage());
    return true;
}
} // namespace G
