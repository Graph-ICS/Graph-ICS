#include "serviceskeleton.hpp"

#include "serversocket.hpp"

ServiceSkeleton::ServiceSkeleton(ServerSocket* server, Connection::Pointer connection, const boost::uuids::uuid& stubId)
    : m_server(server)
    , m_connection(connection)
    , m_stubId(stubId)
{
}

ServiceSkeleton::ServiceSkeleton(ServerSocket* server)
    : m_server(server)
    , m_connection()
    , m_stubId()
{
}

ServiceSkeleton::~ServiceSkeleton()
{
}
