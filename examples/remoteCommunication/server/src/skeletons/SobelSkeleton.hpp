#ifndef SOBELSKELETON_H
#define SOBELSKELETON_H

#include "isobel.hpp"

#include "serviceskeleton.hpp"

class SobelSkeleton : public ServiceSkeleton
{

public:
    SobelSkeleton(ServerSocket* server, Connection::Pointer connection, const boost::uuids::uuid& stubId);
    ~SobelSkeleton();

    void handleRequest(boost::shared_ptr<Entities::Request> request) override;

private:
    ISobel* m_service;
};

#endif // SOBELSKELETON_H
