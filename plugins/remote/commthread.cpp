#include "commthread.h"
#include <QDebug>

CommThread::CommThread()
    : m_ioContext()
    , m_connection(new Connection(m_ioContext))
    , m_stubs()
    , m_syncRequest(nullptr)
    , m_mutex()
    , m_syncWaitCondition()
    , m_connectWaitCondition()
{
    m_isConnected = false;
}

CommThread::~CommThread()
{
    disconnect();
}

CommThread& CommThread::getInstance()
{
    static CommThread instance;
    return instance;
}

bool CommThread::startConnecting(const QString& ip, const unsigned short& port)
{
    if (m_isConnected)
    {
        return false;
    }

    try
    {
        boost::asio::ip::tcp::resolver resolver(m_ioContext);
        boost::asio::ip::tcp::resolver::query query(ip.toStdString(), std::to_string(port));
        boost::asio::ip::tcp::resolver::iterator iterator = resolver.resolve(query);
        m_endpoint = iterator->endpoint();
    }
    catch (const boost::system::system_error& e)
    {
        qDebug() << e.what();
        return false;
    }

    m_ioContext.restart();

    start();
    return true;
}

void CommThread::disconnect()
{
    if (m_isConnected)
    {
        m_connection->getSocket().shutdown(boost::asio::ip::tcp::socket::shutdown_both);
        m_connection->getSocket().close();
        m_isConnected = false;
        m_ioContext.stop();
        wait();
    }
}

void CommThread::handleConnect(const boost::system::error_code& e)
{
    if (!e)
    {
        m_isConnected = true;

        // connection established
        qDebug() << "Connection to server established";
        emit connectHandled(true);

        // start an async read operation and automatically deserialize the received data into m_asyncRequest
        boost::shared_ptr<Entities::Request> request(new Entities::Request());
        m_connection->asyncRead(request,
                                boost::bind(&CommThread::handleRead, this, request, boost::asio::placeholders::error));
    }
    else
    {
        m_isConnected = false;
        emit connectHandled(false);
        qDebug() << "Connecting Error: " + QString::fromStdString(e.message());
    }
}

void CommThread::handleRead(const boost::shared_ptr<Entities::Request> request, const boost::system::error_code& e)
{
    if (!e)
    {
        // start a new async read operation
        boost::shared_ptr<Entities::Request> newRequest(new Entities::Request());
        m_connection->asyncRead(
            newRequest, boost::bind(&CommThread::handleRead, this, newRequest, boost::asio::placeholders::error));

        if (m_syncRequest != nullptr)
        {
            if (m_syncRequest->service() == request->service() && m_syncRequest->function() == request->function() &&
                m_syncRequest->stubid() == request->stubid())
            {
                // handle sync request
                m_syncRequest = request;
                m_syncWaitCondition.wakeOne();
                return;
            }
        }

        // handle async requests
        boost::uuids::uuid stubId = boost::lexical_cast<boost::uuids::uuid>(request->stubid());
        emit handleRequest(request, m_stubs[stubId]);
    }
    else
    {
        // read error
        qDebug() << "Reading Error: " + QString::fromStdString(e.message());

        // what to do when an error occured ???
    }
}

void CommThread::writeAsync(const boost::shared_ptr<Entities::Request> request)
{
    if (m_isConnected)
    {
        m_connection->asyncWrite(
            request, boost::bind(&CommThread::handleWriteNotification, this, boost::asio::placeholders::error));
    }
}

boost::shared_ptr<Entities::Request> CommThread::write(const boost::shared_ptr<Entities::Request> request)
{
    if (!m_isConnected)
    {
        return request;
    }

    m_mutex.lock();

    m_syncRequest = request;
    m_connection->asyncWrite(request,
                             boost::bind(&CommThread::handleWriteNotification, this, boost::asio::placeholders::error));

    // wait until condition gets woken up in handleRead
    m_syncWaitCondition.wait(&m_mutex /*, QDeadlineTimer(5000)*/);

    m_mutex.unlock();

    // request has the information we need
    return m_syncRequest;
}

void CommThread::handleWriteNotification(const boost::system::error_code& e)
{
    if (!e)
    {
        qDebug() << "Write: " + QString::fromStdString(e.message());
    }
    else
    {
        qDebug() << "Writing Error: " + QString::fromStdString(e.message());
    }
}

void CommThread::addStub(const boost::uuids::uuid& stubId, void* stubPtr)
{
    m_stubs.insert(stubId, stubPtr);
}

void CommThread::removeStub(const boost::uuids::uuid& stubId)
{
    m_stubs.remove(stubId);
}

void CommThread::run()
{
    // start asynchroneous connect operation
    m_connection->getSocket().async_connect(
        m_endpoint, boost::bind(&CommThread::handleConnect, this, boost::asio::placeholders::error));
    m_ioContext.run();
}
