#ifndef SKELETONFACTORY_H
#define SKELETONFACTORY_H

#include "connection.hpp"

#include <boost/uuid/uuid.hpp>

class SobelSkeleton;
class ServerSocket;

class SkeletonFactory
{
public:
    SkeletonFactory();
    ~SkeletonFactory();

    SobelSkeleton* createSobelSkeleton(ServerSocket* server, Connection::Pointer connection,
                                       const boost::uuids::uuid& stubId);
};

#endif // SKELETONFACTORY_H
