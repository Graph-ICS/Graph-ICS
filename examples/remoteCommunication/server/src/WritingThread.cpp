#include <writingthread.hpp>

#include <boost/bind.hpp>
#include <boost/chrono.hpp>
#include <iostream>

WritingThread::WritingThread()
    : m_condition()
    , m_runMutex()
    , m_dequeMutex()
    , m_deque()
    , m_shutdown(false)
{
    m_thread = boost::thread(boost::bind(&WritingThread::run, this));
}

WritingThread::~WritingThread()
{
    m_shutdown = true;
    m_condition.notify_one();

    m_thread.join();
}

void WritingThread::addWriteRequest(Connection::Pointer connection, boost::shared_ptr<Entities::Request> request,
                                    bool highPriority)
{
    {
        boost::unique_lock<boost::mutex> lock(m_dequeMutex);

        if (highPriority)
        {
            m_deque.push_front(std::make_pair(connection, request));
        }
        else
        {
            m_deque.push_back(std::make_pair(connection, request));
        }
    }
    m_condition.notify_one();
}

void WritingThread::removeWriteRequestsForConnection(Connection::Pointer connection)
{
    boost::unique_lock<boost::mutex> lock(m_dequeMutex);

    if (m_deque.size() > 0)
    {
        for (auto it = m_deque.begin(); it != m_deque.end(); it++)
        {
            if (it->first == connection)
            {
                m_deque.erase(it);
            }
        }
    }
}

void WritingThread::handleWriteErrorCode(const boost::system::error_code& error)
{
    if (!error)
    {
        // std::cout << "write: " + error.message() + "\n";
    }
    else
    {
        std::cerr << "write error: " + error.message() + "\n";
    }
}

void WritingThread::run()
{
    while (true)
    {
        if (m_shutdown)
        {
            return;
        }

        if (m_deque.size() == 0)
        {
            boost::unique_lock<boost::mutex> lock(m_runMutex);
            m_condition.wait(lock);
        }
        else
        {
            Connection::Pointer connection;
            boost::shared_ptr<Entities::Request> request;

            {
                boost::unique_lock<boost::mutex> lock(m_dequeMutex);
                std::pair<Connection::Pointer, boost::shared_ptr<Entities::Request>> job = m_deque.front();
                connection = job.first;
                request = job.second;
                m_deque.pop_front();
            }
            try
            {
                handleWriteErrorCode(connection->write(request));
            }
            catch (const boost::wrapexcept<boost::system::system_error>& e)
            {
                std::cerr << "write error: " << e.what() << "\nClient may be unexpectedly disconnected." << std::endl;
            }
        }
    }
}