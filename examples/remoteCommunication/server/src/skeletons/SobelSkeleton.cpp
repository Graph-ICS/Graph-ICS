#include "sobelskeleton.hpp"

#include "serversocket.hpp"

#include "requestprotocol.h"
#include "sobel.hpp"

#include <cv.hpp>

SobelSkeleton::SobelSkeleton(ServerSocket* server, Connection::Pointer connection, const boost::uuids::uuid& stubId)
    : ServiceSkeleton(server, connection, stubId)
    , m_service(new Sobel())
{
}

SobelSkeleton::~SobelSkeleton()
{
    delete m_service;
}

void SobelSkeleton::handleRequest(boost::shared_ptr<Entities::Request> request)
{
    bool returnRequest = false;

    switch (request->function())
    {
        case Protocol::functions::Sobel::getXDerivative:
            returnRequest = true;
            request->set_intvalue(m_service->getXDerivative());
            break;
        case Protocol::functions::Sobel::getYDerivative:
            returnRequest = true;
            request->set_intvalue(m_service->getYDerivative());
            break;
        case Protocol::functions::Sobel::setXDerivative:
            m_service->setXDerivative(request->intvalue());
            break;
        case Protocol::functions::Sobel::setYDerivative:
            m_service->setYDerivative(request->intvalue());
            break;
        case Protocol::functions::Sobel::calculate:
            returnRequest = true;
            {
                std::vector<uchar> encodedImage(request->image().data().begin(), request->image().data().end());
                cv::Mat input;
                cv::imdecode(encodedImage, cv::ImreadModes::IMREAD_COLOR, &input);

                std::cout << "Calculating Sobel\n";
                m_service->calculate(input);
                std::cout << "Finished Sobel\n";

                std::vector<int> encodeParams;
                encodeParams.push_back(CV_IMWRITE_JPEG_QUALITY);
                encodeParams.push_back(70);
                cv::imencode(".jpeg", input, encodedImage, encodeParams);

                Entities::Image* image = new Entities::Image();
                image->set_data((char*)encodedImage.data(), encodedImage.size());
                image->set_encoding("jpeg");

                request->set_allocated_image(image);
            }
            break;
    }

    if (returnRequest)
    {
        m_server->write(m_connection, request);
    }
}
