#ifndef REQUESTHANDLER_H
#define REQUESTHANDLER_H

#include "Entities.pb.h"

#include <boost/shared_ptr.hpp>

#include <QObject>

class RequestHandler : public QObject
{
    Q_OBJECT
public:
    RequestHandler(QObject* parent = nullptr);
    ~RequestHandler();

    void handleRequest(boost::shared_ptr<Entities::Request> request);

private:
};

#endif // REQUESTHANDLER_H