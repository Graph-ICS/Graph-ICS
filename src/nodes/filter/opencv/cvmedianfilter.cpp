#include "cvmedianfilter.h"

#include <cv.h>
#include <opencv2/imgproc/imgproc.hpp>

#include "imageconverter.h"
#include <QDebug>

CvMedianFilter::CvMedianFilter()
{
    registerAttribute("kernelSize", new NodeIntAttribute(1, 199, 1, 2));
    m_nodeName = "CvMedian";
}


bool CvMedianFilter::retrieveResult()
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

            cv::Mat cvImage = m_img.getCvMatImage();

            if(cvImage.type() == CV_8UC1) {
                cv::cvtColor(cvImage, cvImage, CV_GRAY2RGB);
            }

            cv::medianBlur(cvImage, cvImage, getAttributeValue("kernelSize").toInt());

            m_img.setImage(cvImage);

        } catch (int e) {
            qDebug() << "CvMedianFilter. Exception Nr. " << e << '\n';
            return false;
        }
    }
    return true;
}
