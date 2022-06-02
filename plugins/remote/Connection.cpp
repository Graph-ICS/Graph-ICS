#include "Connection.hpp"
#include <iostream>

Connection::Connection(boost::asio::io_context& ioContext)
    : m_ioContext(ioContext)
    , m_socket(ioContext)
{
}

boost::asio::ip::tcp::socket& Connection::getSocket()
{
    return m_socket;
}
