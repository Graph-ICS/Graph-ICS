#include "cvdilation.h"
#include "opencv2/imgproc.hpp"
#include "opencv2/highgui.hpp"

CvDilation::CvDilation()
{
    m_nodeName = "CvDilation";
    m_list << "Rectangle" << "Cross" << "Ellipse";
    registerAttribute("element", new NodeComboBoxAttribute(m_list));
    registerAttribute("kernelSize", new NodeIntAttribute(1, 21));
}

bool CvDilation::retrieveResult()
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
            int kernel = getAttributeValue("kernelSize").toInt();
            int index = m_list.indexOf(getAttributeValue("element").toString());
            cv::Mat element = cv::getStructuringElement(index,
                                                        cv::Size(2 * kernel + 1, 2 * kernel + 1),
                                                        cv::Point(kernel, kernel));
            cv::dilate(cvImage, cvImage, element);

            m_img.setImage(cvImage);

        } catch (int e) {
            qDebug() << "CvDilation. Exception Nr. " << e << '\n';
            return false;
        }
    }
    return true;
}
