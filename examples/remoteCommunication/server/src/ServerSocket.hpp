#pragma once

#ifndef SERVERSOCKET_HPP
#define SERVERSOCKET_HPP

// stdlib
#include <iostream>

// boost
#include <boost/asio.hpp>
#include <boost/bind.hpp>

#include "serviceskeleton.hpp"
#include "writingthread.hpp"

#include "factoryskeleton.hpp"

class ServerSocket
{

public:
    ServerSocket(boost::asio::io_context& ioContext, const unsigned short& port);
    ~ServerSocket();

    void handleAccept(Connection::Pointer connection, const boost::system::error_code& error);

    void handleRead(Connection::Pointer connection, boost::shared_ptr<Entities::Request> request,
                    const boost::system::error_code& error);

    // update calls such as image sending should set highPriority to false due to blocking of other write requests
    void write(Connection::Pointer connection, boost::shared_ptr<Entities::Request> request, bool highPriority = true);

    void addServiceSkeleton(Connection::Pointer connection, const boost::uuids::uuid& id,
                            ServiceSkeleton::Pointer skeleton);
    void removeServiceSkeleton(Connection::Pointer connection, const boost::uuids::uuid& id);

private:
    boost::asio::io_context& m_ioContext;
    boost::asio::ip::tcp::acceptor m_acceptor;

    WritingThread m_writingThread;

    Entities::Request m_request;

    FactorySkeleton m_factorySkeleton;
    std::map<Connection::Pointer, std::map<boost::uuids::uuid, ServiceSkeleton::Pointer>> m_serviceSkeletons;
};
#endif // SERVERSOCKET_H
