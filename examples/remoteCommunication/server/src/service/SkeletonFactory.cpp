#include "skeletonfactory.hpp"

#include "serversocket.hpp"
#include "sobelskeleton.hpp"

SkeletonFactory::SkeletonFactory()
{
}

SkeletonFactory::~SkeletonFactory()
{
}

SobelSkeleton* SkeletonFactory::createSobelSkeleton(ServerSocket* server, Connection::Pointer connection,
                                                    const boost::uuids::uuid& stubId)
{
    return new SobelSkeleton(server, connection, stubId);
}
