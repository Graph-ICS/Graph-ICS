#ifndef SERVICESKELETON_H
#define SERVICESKELETON_H

#include "Entities.pb.h"
#include "connection.hpp"


#include <boost/lexical_cast.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/uuid/uuid.hpp>
#include <boost/uuid/uuid_io.hpp>

class ServerSocket;

class ServiceSkeleton
{

public:
    ServiceSkeleton(ServerSocket* server, Connection::Pointer connection, const boost::uuids::uuid& stubId);
    ServiceSkeleton(ServerSocket* server);
    ~ServiceSkeleton();

    typedef boost::shared_ptr<ServiceSkeleton> Pointer;

    virtual void handleRequest(boost::shared_ptr<Entities::Request> request) = 0;

protected:
    ServerSocket* m_server;
    Connection::Pointer m_connection;
    boost::uuids::uuid m_stubId;
};

#endif // SERVICESKELETON_H
