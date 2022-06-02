#include "sobelstub.h"

#include "Entities.pb.h"
#include "commthread.h"
#include "requestprotocol.h"


#include <cv.hpp>

SobelStub::SobelStub(RemoteExampleNode* node)
    : m_node(node)
    , m_id(node->getStubId())
{
    CommThread::getInstance().addStub(m_id, this);
    boost::shared_ptr<Entities::Request> request(new Entities::Request);

    request->set_service(Protocol::services::SkeletonFactory);
    request->set_function(Protocol::functions::SkeletonFactory::createSobelSkeleton);
    request->set_stubid(boost::uuids::to_string(m_id));

    CommThread::getInstance().writeAsync(request);
}

SobelStub::~SobelStub()
{

    boost::shared_ptr<Entities::Request> request(new Entities::Request);

    request->set_service(Protocol::services::SkeletonFactory);
    request->set_function(Protocol::functions::SkeletonFactory::destroy);
    request->set_stubid(boost::uuids::to_string(m_id));

    CommThread::getInstance().writeAsync(request);

    CommThread::getInstance().removeStub(m_id);
}

int SobelStub::getXDerivative() const
{
    boost::shared_ptr<Entities::Request> request(new Entities::Request);

    request->set_service(Protocol::services::Sobel);
    request->set_function(Protocol::functions::Sobel::getXDerivative);
    request->set_stubid(boost::uuids::to_string(m_id));

    request = CommThread::getInstance().write(request);
    return request->intvalue();
}

void SobelStub::setXDerivative(const int& xDerivative)
{
    boost::shared_ptr<Entities::Request> request(new Entities::Request);

    request->set_service(Protocol::services::Sobel);
    request->set_function(Protocol::functions::Sobel::setXDerivative);
    request->set_stubid(boost::uuids::to_string(m_id));

    request->set_intvalue(xDerivative);

    CommThread::getInstance().writeAsync(request);
}

int SobelStub::getYDerivative() const
{
    boost::shared_ptr<Entities::Request> request(new Entities::Request);

    request->set_service(Protocol::services::Sobel);
    request->set_function(Protocol::functions::Sobel::getYDerivative);
    request->set_stubid(boost::uuids::to_string(m_id));

    request = CommThread::getInstance().write(request);
    return request->intvalue();
}

void SobelStub::setYDerivative(const int& yDerivative)
{
    boost::shared_ptr<Entities::Request> request(new Entities::Request);

    request->set_service(Protocol::services::Sobel);
    request->set_function(Protocol::functions::Sobel::setYDerivative);
    request->set_stubid(boost::uuids::to_string(m_id));

    request->set_intvalue(yDerivative);

    CommThread::getInstance().writeAsync(request);
}

void SobelStub::calculate(cv::Mat& input)
{
    // convert cv::mat to byte array
    std::vector<uchar> encodedImage;
    ImageConverter::CvMatToJpegImage(input, encodedImage, 70);

    // setup request
    boost::shared_ptr<Entities::Request> request(new Entities::Request);

    request->set_service(Protocol::services::Sobel);
    request->set_function(Protocol::functions::Sobel::calculate);
    request->set_stubid(boost::uuids::to_string(m_id));

    Entities::Image* image = new Entities::Image();
    image->set_data((char*)encodedImage.data(), encodedImage.size());
    image->set_encoding("jpeg");

    request->set_allocated_image(image);

    request = CommThread::getInstance().write(request);

    // convert returned image to cv::Mat
    encodedImage = std::vector<uchar>(request->image().data().begin(), request->image().data().end());
    ImageConverter::JpegImageToCvMat(encodedImage, input);
}
