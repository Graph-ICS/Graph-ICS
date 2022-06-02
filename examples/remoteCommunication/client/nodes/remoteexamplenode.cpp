#include "remoteexamplenode.h"

#include <boost/uuid/uuid_generators.hpp>

RemoteExampleNode::RemoteExampleNode(TYPE type)
    : Node(type)
    , m_stubId(boost::uuids::random_generator()())
{
}

RemoteExampleNode::~RemoteExampleNode()
{
}

void RemoteExampleNode::addRemoteInNode(Node* /*inNode*/, const int& /*outPortPosition*/, const int& /*inPortPosition*/)
{
    // Here could be a Server-site node connection call
}

void RemoteExampleNode::removeRemoteInNode(Node* /*inNode*/, const int& /*inPortPosition*/)
{
}

boost::uuids::uuid RemoteExampleNode::getStubId() const
{
    return m_stubId;
}
