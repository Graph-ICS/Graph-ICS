#ifndef COMMTHREAD_H
#define COMMTHREAD_H

#include <boost/asio.hpp>
#include <boost/lexical_cast.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/uuid/uuid.hpp>
#include <boost/uuid/uuid_io.hpp>

#include <QMap>
#include <QMutex>
#include <QThread>
#include <QWaitCondition>

#include "Entities.pb.h"
#include "connection.hpp"

class CommThread : public QThread
{
    Q_OBJECT
public:
    CommThread(CommThread const&) = delete;
    void operator=(CommThread const&) = delete;
    CommThread(CommThread&&) = delete;
    CommThread& operator=(CommThread&&) = delete;
    ~CommThread();

    static CommThread& getInstance();

    Q_INVOKABLE bool startConnecting(const QString& ip, const unsigned short& port);
    Q_INVOKABLE void disconnect();

    void handleConnect(const boost::system::error_code& e);
    void handleRead(const boost::shared_ptr<Entities::Request> request, const boost::system::error_code& e);

    void writeAsync(const boost::shared_ptr<Entities::Request> request);
    boost::shared_ptr<Entities::Request> write(const boost::shared_ptr<Entities::Request> request);
    void handleWriteNotification(const boost::system::error_code& e);

    void addStub(const boost::uuids::uuid& stubId, void* stubPtr);
    void removeStub(const boost::uuids::uuid& stubId);

signals:
    void connectHandled(bool isConnected);
    void handleRequest(boost::shared_ptr<Entities::Request>, void* stubPtr);

protected:
    void run() override;

private:
    CommThread();

    boost::asio::io_context m_ioContext;
    boost::asio::ip::tcp::endpoint m_endpoint;
    bool m_isConnected;
    Connection::Pointer m_connection;

    QMap<boost::uuids::uuid, void*> m_stubs;

    boost::shared_ptr<Entities::Request> m_syncRequest;

    QMutex m_mutex;
    QWaitCondition m_syncWaitCondition;
    QWaitCondition m_connectWaitCondition;
};

#endif // COMMTHREAD_H
