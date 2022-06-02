#ifndef REMOTESOBEL_H
#define REMOTESOBEL_H

#include "remoteexamplenode.h"

#include "isobel.hpp"

namespace G
{
class RemoteSobel : public RemoteExampleNode
{
public:
    RemoteSobel();
    ~RemoteSobel();

    bool retrieveResult() override;
    void onAttributeValueChanged(G::Attribute* attribute) override;

private:
    G::Attribute* m_xDerivative;
    G::Attribute* m_yDerivative;
    G::Port m_inPort;
    G::Port m_outPort;

    ISobel* m_service;
};
} // namespace G

#endif // REMOTESOBEL_H
