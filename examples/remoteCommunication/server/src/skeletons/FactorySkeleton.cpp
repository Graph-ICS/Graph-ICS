#include "factoryskeleton.hpp"

#include "requestprotocol.h"
#include "serversocket.hpp"

#include "sobelskeleton.hpp"

#include <boost/lexical_cast.hpp>
#include <boost/uuid/uuid_io.hpp>

FactorySkeleton::FactorySkeleton(ServerSocket* server)
    : m_service(new SkeletonFactory())
    , m_server(server)
{
}

FactorySkeleton::~FactorySkeleton()
{
    delete m_service;
}

void FactorySkeleton::handleRequest(Connection::Pointer connection, boost::shared_ptr<Entities::Request> request)
{
    boost::uuids::uuid stubId = boost::lexical_cast<boost::uuids::uuid>(request->stubid());
    switch (request->function())
    {
        case Protocol::functions::SkeletonFactory::createSobelSkeleton:
            m_server->addServiceSkeleton(
                connection, stubId,
                ServiceSkeleton::Pointer(m_service->createSobelSkeleton(m_server, connection, stubId)));
            break;
        case Protocol::functions::SkeletonFactory::destroy:
            m_server->removeServiceSkeleton(connection, stubId);
            break;
        default:
            break;
    }
}
