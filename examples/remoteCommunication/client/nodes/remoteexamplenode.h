#ifndef REMOTEEXAMPLENODE_H
#define REMOTEEXAMPLENODE_H

#include <node.h>

#include <boost/uuid/uuid.hpp>
#include <boost/uuid/uuid_io.hpp>

#include "requesthandler.h"

class RemoteExampleNode : public G::Node
{
public:
    RemoteExampleNode(TYPE type = FILTER);
    virtual ~RemoteExampleNode();

    void addRemoteInNode(G::Node* inNode, const int& outPortPosition, const int& inPortPosition);
    void removeRemoteInNode(G::Node* inNode, const int& inPortPosition);

    boost::uuids::uuid getStubId() const;

protected:
    const boost::uuids::uuid m_stubId;

    static RequestHandler requestHandler;
};

#endif // REMOTEEXAMPLENODE_H
