
// https://www.boost.org/doc/libs/1_38_0/doc/html/boost_asio/example/serialization/connection.hpp

#ifndef CONNECTION_H
#define CONNECTION_H

#include <boost/asio.hpp>

#include <boost/bind.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/tuple/tuple.hpp>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

class Connection
{
public:
    Connection(boost::asio::io_context& ioContext);

    typedef boost::shared_ptr<Connection> Pointer;

    boost::asio::ip::tcp::socket& getSocket();

    template <typename T, typename Handler> void asyncWrite(const boost::shared_ptr<T> t, Handler handler);

    template <typename T> boost::system::error_code write(const boost::shared_ptr<T> t);

    template <typename T, typename Handler> void asyncRead(boost::shared_ptr<T> t, Handler handler);

private:
    template <typename T, typename Handler>
    void handleReadHeader(const boost::system::error_code& e, boost::shared_ptr<T> t, boost::tuple<Handler> handler);

    template <typename T, typename Handler>
    void handleReadData(const boost::system::error_code& e, boost::shared_ptr<T> t, boost::tuple<Handler> handler);

    boost::asio::io_context& m_ioContext;
    boost::asio::ip::tcp::socket m_socket;
    // size of the header
    enum
    {
        headerLength = 16
    };

    std::string m_outboundHeader;
    std::string m_outboundData;

    char m_inboundHeader[headerLength];
    std::vector<char> m_inboundData;
};

template <typename T, typename Handler> void Connection::asyncWrite(const boost::shared_ptr<T> t, Handler handler)
{
    t->SerializeToString(&m_outboundData);

    // create header
    std::ostringstream header_stream;
    header_stream << std::setw(headerLength) << std::hex << m_outboundData.size();

    if (!header_stream || header_stream.str().size() != headerLength)
    {
        // error call handler function with error code
        boost::system::error_code error(boost::asio::error::invalid_argument);
        boost::asio::post(m_ioContext, boost::bind(handler, error));
        return;
    }

    m_outboundHeader = header_stream.str();

    // concat the header and the data and write to socket
    std::vector<boost::asio::const_buffer> buffers;
    buffers.push_back(boost::asio::buffer(m_outboundHeader));
    buffers.push_back(boost::asio::buffer(m_outboundData));
    boost::asio::async_write(m_socket, buffers, handler);
}

template <typename T> boost::system::error_code Connection::write(const boost::shared_ptr<T> t)
{
    t->SerializeToString(&m_outboundData);

    // create header
    std::ostringstream header_stream;
    header_stream << std::setw(headerLength) << std::hex << m_outboundData.size();

    if (!header_stream || header_stream.str().size() != headerLength)
    {
        // error call handler function with error code
        return boost::system::error_code(boost::asio::error::invalid_argument);
    }

    m_outboundHeader = header_stream.str();

    // concat the header and the data and write to socket
    std::vector<boost::asio::const_buffer> buffers;
    buffers.push_back(boost::asio::buffer(m_outboundHeader));
    buffers.push_back(boost::asio::buffer(m_outboundData));
    boost::asio::write(m_socket, buffers);

    return boost::system::error_code();
}

template <typename T, typename Handler> void Connection::asyncRead(boost::shared_ptr<T> t, Handler handler)
{
    // create function pointer to handleReadHeader function
    void (Connection::*funcPtr)(const boost::system::error_code&, boost::shared_ptr<T>, boost::tuple<Handler>) =
        &Connection::handleReadHeader<T, Handler>;
    // start reading and execute handleReadHeader
    boost::asio::async_read(
        m_socket, boost::asio::buffer(m_inboundHeader),
        boost::bind(funcPtr, this, boost::asio::placeholders::error, t, boost::make_tuple(handler)));
}

template <typename T, typename Handler>
void Connection::handleReadHeader(const boost::system::error_code& e, boost::shared_ptr<T> t,
                                  boost::tuple<Handler> handler)
{
    if (e)
    {
        boost::get<0>(handler)(e);
    }
    else
    {
        // get the length of the serialized data from the header
        std::istringstream is(std::string(m_inboundHeader, headerLength));
        std::size_t m_inboundDatasize = 0;

        if (!(is >> std::hex >> m_inboundDatasize))
        {
            // error header is invalid, call handler function with error
            boost::system::error_code error(boost::asio::error::invalid_argument);
            boost::get<0>(handler)(error);
            return;
        }

        // read the serialized data
        m_inboundData.resize(m_inboundDatasize);
        // create pointer to handleReadData function
        void (Connection::*funcPtr)(const boost::system::error_code&, boost::shared_ptr<T>, boost::tuple<Handler>) =
            &Connection::handleReadData<T, Handler>;

        // start reading and execute handleReadData function
        boost::asio::async_read(m_socket, boost::asio::buffer(m_inboundData),
                                boost::bind(funcPtr, this, boost::asio::placeholders::error, t, handler));
    }
}

template <typename T, typename Handler>
void Connection::handleReadData(const boost::system::error_code& e, boost::shared_ptr<T> t,
                                boost::tuple<Handler> handler)
{
    if (e)
    {
        boost::get<0>(handler)(e);
    }
    else
    {
        // try to deserialize the received data
        try
        {
            std::string archive_data(&m_inboundData[0], m_inboundData.size());
            t->ParseFromString(archive_data);
        }
        catch (...)
        {
            // deserialization went wrong, call handler function with error
            boost::system::error_code error(boost::asio::error::invalid_argument);
            boost::get<0>(handler)(error);
            return;
        }

        // call handler function to inform about success
        boost::get<0>(handler)(e);
    }
}

#endif // CONNECTION_H
