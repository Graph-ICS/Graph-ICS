#include "opencv2/highgui.hpp"
#include "opencv2/imgcodecs.hpp"
#include "opencv2/imgproc.hpp"

#include "cvhistogramcalculation.h"

CvHistogramCalculation::CvHistogramCalculation()
{
    m_nodeName = "CvHistogramCalculation";
    m_outputType = "GData";
}

bool CvHistogramCalculation::retrieveResult()
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
            m_data.clear();
            // convert to grayscale
            cv::Mat cvImage = m_img.getCvMatImage();
            if(cvImage.type() == CV_8UC3) {
                cv::cvtColor(cvImage, cvImage, CV_RGB2GRAY);
            }

            int histSize = 256;
            float range[] = {0, 256};
            const float* histRange = { range };

            cv::Mat hist_result;
            cv::calcHist(&cvImage, 1, 0, cv::Mat(), hist_result, 1, &histSize, &histRange, true, false);

            for(int i = 0; i < histSize; i++){
                float y;
                y = hist_result.at<float>(i);
                m_data.append(QPointF(i, y));
            }

            m_img.clear();


        } catch (int e) {
            qDebug() << m_nodeName << " Exception Nr. " << e << '\n';
            return false;
        }
    }
    return true;
}
