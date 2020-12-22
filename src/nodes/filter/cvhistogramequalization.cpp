#include "cvhistogramequalization.h"
#include "opencv2/imgcodecs.hpp"
#include "opencv2/highgui.hpp"
#include "opencv2/imgproc.hpp"
#include "imageconverter.h"
#include <opencv2/imgproc/imgproc.hpp>


CvHistogramEqualization::CvHistogramEqualization()
{
    m_nodeName = "CvHistogramEqualization";
}

bool CvHistogramEqualization::retrieveResult()
{
    if (m_inNodes.size() < 1) {
        return false;
    }
    else {
        try {
            m_img = m_inNodes[0]->getResult();

            if(!m_img.isSet()){
                return false;
            }

            cv::Mat cvImage = m_img.getCvMatImage();
            if(cvImage.type() == CV_8UC3) {
                cv::cvtColor(cvImage, cvImage, CV_RGB2GRAY);
            }

            cv::equalizeHist(cvImage, cvImage);

            m_img.setImage(cvImage);

        } catch (int e) {
            qDebug() << "CvHistogramEqualization. Exception Nr. " << e << '\n';
            return false;
        }
    }
    return true;

}
