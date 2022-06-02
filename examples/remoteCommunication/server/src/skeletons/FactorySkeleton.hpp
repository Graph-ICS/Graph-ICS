#ifndef FACTORYSKELETON_HPP
#define FACTORYSKELETON_HPP

#include "skeletonfactory.hpp"

#include "connection.hpp"
#include "Entities.pb.h"

class ServerSocket;

class FactorySkeleton
{

public:
    FactorySkeleton(ServerSocket* server);
    ~FactorySkeleton();

    void handleRequest(Connection::Pointer connection, boost::shared_ptr<Entities::Request> request);

private:
    SkeletonFactory* m_service;
    ServerSocket* m_server;
};

#endif // FACTORYSKELETON_HPP
