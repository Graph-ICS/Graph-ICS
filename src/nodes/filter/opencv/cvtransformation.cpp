#include "cvtransformation.h"

#include "opencv2/imgcodecs.hpp"
#include "opencv2/highgui.hpp"
#include "opencv2/imgproc.hpp"

CvTransformation::CvTransformation()
{
    m_nodeName = "CvTransformation";
    m_warningMessage = "";
    registerAttribute("angle", new NodeDoubleAttribute(0.0, 180.0, -180.0));
    registerAttribute("scale", new NodeDoubleAttribute(1.0, 2.0, 0.01));

}

bool CvTransformation::retrieveResult()
{
    if (m_inNodes.size() < 1) {
        return false;
    }
    else {
        try {
            m_img = m_inNodes[0]->getResultImage();

            if(m_img.isEmpty()){
                return false;
            }

            cv::Mat src = m_img.getCvMatImage();

            cv::Point2f srcTri[3];
            srcTri[0] = cv::Point2f( 0.f, 0.f );
            srcTri[1] = cv::Point2f( src.cols - 1.f, 0.f );
            srcTri[2] = cv::Point2f( 0.f, src.rows - 1.f );

            cv::Point2f dstTri[3];
            dstTri[0] = cv::Point2f( 0.f, 0.f );
            dstTri[1] = cv::Point2f( src.cols - 1.f, 0.f );
            dstTri[2] = cv::Point2f( 0.f, src.rows - 1.f );

            cv::Mat warp_mat = getAffineTransform( srcTri, dstTri );
            cv::Mat warp_dst = cv::Mat::zeros( src.rows, src.cols, src.type() );
            cv::warpAffine( src, warp_dst, warp_mat, warp_dst.size() );

            cv::Point center = cv::Point( warp_dst.cols/2, warp_dst.rows/2 );
            double angle = getAttributeValue("angle").toDouble();
            double scale = getAttributeValue("scale").toDouble();

            cv::Mat rot_mat = cv::getRotationMatrix2D( center, angle, scale );
            cv::Mat warp_rotate_dst;
            cv::warpAffine( warp_dst, warp_rotate_dst, rot_mat, warp_dst.size() );


            m_img.setImage(warp_rotate_dst);

        } catch (int e) {
            qDebug() << m_nodeName << " Exception Nr. " << e << '\n';
            return false;
        }
    }
    return true;
}
