#ifndef WRITINGTHREAD_H
#define WRITINGTHREAD_H

#include <boost/thread.hpp>
#include <boost/thread/condition_variable.hpp>
#include <boost/thread/mutex.hpp>

#include <deque>
#include <functional>

#include "connection.hpp"

#include "Entities.pb.h"

class WritingThread
{
public:
    WritingThread();
    ~WritingThread();

    void addWriteRequest(Connection::Pointer connection, boost::shared_ptr<Entities::Request> request,
                         bool highPriority);
    void removeWriteRequestsForConnection(Connection::Pointer connection);

private:
    boost::thread m_thread;
    boost::condition_variable m_condition;
    boost::mutex m_runMutex;
    boost::mutex m_dequeMutex;

    std::deque<std::pair<Connection::Pointer, boost::shared_ptr<Entities::Request>>> m_deque;

    bool m_shutdown;
    void handleWriteErrorCode(const boost::system::error_code& error);
    void run();
};

#endif