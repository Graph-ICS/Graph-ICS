#include "cvtransformation.h"

#include "opencv2/highgui.hpp"
#include "opencv2/imgcodecs.hpp"
#include "opencv2/imgproc.hpp"

namespace G
{

CvTransformation::CvTransformation()
    : Node("CvTransformation")
    , m_inPort(Port::TYPE::GIMAGE)
    , m_outPort(Port::TYPE::GIMAGE)
    , m_angle(attributeFactory.makeDoubleTextField(0.0, -180.0, 180.0, "Angle"))
    , m_scale(attributeFactory.makeDoubleTextField(1.0, 0.01, 2.0, "Scale"))
{
    registerPorts({&m_inPort}, {&m_outPort});
    registerAttribute("angle", m_angle);
    registerAttribute("scale", m_scale);
}

bool CvTransformation::retrieveResult()
{
    try
    {
        cv::Mat& src = m_inPort.getGImage()->getCvMatImage();

        cv::Point2f srcTri[3];
        srcTri[0] = cv::Point2f(0.f, 0.f);
        srcTri[1] = cv::Point2f(src.cols - 1.f, 0.f);
        srcTri[2] = cv::Point2f(0.f, src.rows - 1.f);

        cv::Point2f dstTri[3];
        dstTri[0] = cv::Point2f(0.f, 0.f);
        dstTri[1] = cv::Point2f(src.cols - 1.f, 0.f);
        dstTri[2] = cv::Point2f(0.f, src.rows - 1.f);

        cv::Mat warp_mat = getAffineTransform(srcTri, dstTri);
        cv::Mat warp_dst = cv::Mat::zeros(src.rows, src.cols, src.type());
        cv::warpAffine(src, warp_dst, warp_mat, warp_dst.size());

        cv::Point center = cv::Point(warp_dst.cols / 2, warp_dst.rows / 2);
        double angle = m_angle->getValue().toDouble();
        double scale = m_scale->getValue().toDouble();

        cv::Mat rot_mat = cv::getRotationMatrix2D(center, angle, scale);
        cv::Mat warp_rotate_dst;
        cv::warpAffine(warp_dst, warp_rotate_dst, rot_mat, warp_dst.size());

        m_outPort.getGImage()->setImage(warp_rotate_dst);
    }
    catch (int e)
    {
        qDebug() << "CvTransformation Exception Nr. " << e << '\n';
        return false;
    }

    return true;
}
} // namespace G
