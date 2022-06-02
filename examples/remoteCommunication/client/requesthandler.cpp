#include "requesthandler.h"

#include "commthread.h"

RequestHandler::RequestHandler(QObject* parent)
    : QObject(parent)
{
    QObject::connect(&CommThread::getInstance(), &CommThread::handleRequest, this, &RequestHandler::handleRequest);
}

RequestHandler::~RequestHandler()
{
}

void RequestHandler::handleRequest(boost::shared_ptr<Entities::Request> request)
{
}
