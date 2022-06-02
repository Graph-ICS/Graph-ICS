#include "serversocket.hpp"

#include "factoryskeleton.hpp"
#include "requestprotocol.h"

#include <boost/lexical_cast.hpp>
#include <boost/uuid/uuid_io.hpp>

ServerSocket::ServerSocket(boost::asio::io_context& ioContext, const unsigned short& port)
    : m_ioContext(ioContext)
    , m_acceptor(ioContext, boost::asio::ip::tcp::endpoint(boost::asio::ip::tcp::v4(), port))
    , m_writingThread()
    , m_factorySkeleton(this)
{
    Connection::Pointer connection(new Connection(m_ioContext));

    m_acceptor.async_accept(connection->getSocket(), boost::bind(&ServerSocket::handleAccept, this, connection,
                                                                 boost::asio::placeholders::error));
}

ServerSocket::~ServerSocket()
{
}

void ServerSocket::handleAccept(Connection::Pointer connection, const boost::system::error_code& error)
{
    if (!error)
    {
        // start connection with client
        // one ConnectionHandler instance used for one client
        boost::shared_ptr<Entities::Request> request(new Entities::Request());
        connection->asyncRead(request, boost::bind(&ServerSocket::handleRead, this, connection, request,
                                                   boost::asio::placeholders::error));

        std::cout << "Client accepted" << std::endl;

        // create new Connection instance and bind to handleAccept
        // start async accept
        Connection::Pointer newConnection(new Connection(m_ioContext));
        m_acceptor.async_accept(
            newConnection->getSocket(),
            boost::bind(&ServerSocket::handleAccept, this, newConnection, boost::asio::placeholders::error));
    }
    else
    {
        std::cerr << "accept error: " + error.message();
    }
}

void ServerSocket::handleRead(Connection::Pointer connection, boost::shared_ptr<Entities::Request> request,
                              const boost::system::error_code& error)
{
    if (!error)
    {
        std::cout << "Reading Request: " << request->service() << " " << request->function() << " " << request->stubid()
                  << std::endl;

        switch (request->service())
        {
            case Protocol::services::SkeletonFactory:
                m_factorySkeleton.handleRequest(connection, request);
                break;

            default:
                try
                {
                    m_serviceSkeletons.at(connection)
                        .at(boost::lexical_cast<boost::uuids::uuid>(request->stubid()))
                        ->handleRequest(request);
                }
                catch (const std::exception& e)
                {
                    std::cerr << "ERROR: " << e.what() << '\n';
                    std::cerr
                        << "Maybe the Service is not added (with addServiceClient) in the constructor of the proxy."
                        << std::endl;
                }

                break;
        }

        // start next read operation
        boost::shared_ptr<Entities::Request> newRequest(new Entities::Request());
        connection->asyncRead(newRequest, boost::bind(&ServerSocket::handleRead, this, connection, newRequest,
                                                      boost::asio::placeholders::error));
    }
    else
    {
        std::cerr << "read error: " + error.message() << "\nClient may be unexpectedly disconnected." << std::endl;
        try
        {
            m_writingThread.removeWriteRequestsForConnection(connection);
            m_serviceSkeletons.erase(connection);
        }
        catch (const boost::wrapexcept<boost::system::system_error>& e)
        {
            std::cerr << e.what() << '\n';
        }
    }
}

void ServerSocket::write(Connection::Pointer connection, boost::shared_ptr<Entities::Request> request,
                         bool highPriority)
{
    m_writingThread.addWriteRequest(connection, request, highPriority);
}

void ServerSocket::addServiceSkeleton(Connection::Pointer connection, const boost::uuids::uuid& id,
                                      ServiceSkeleton::Pointer skeleton)
{
    if (m_serviceSkeletons.find(connection) == m_serviceSkeletons.end())
    {
        m_serviceSkeletons.insert(std::make_pair(connection, std::map<boost::uuids::uuid, ServiceSkeleton::Pointer>()));
    }

    m_serviceSkeletons[connection].insert(std::make_pair(id, skeleton));
}

void ServerSocket::removeServiceSkeleton(Connection::Pointer connection, const boost::uuids::uuid& id)
{
    m_serviceSkeletons[connection].erase(id);
}
