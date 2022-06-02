#include "cvhistogramequalization.h"
#include "imageconverter.h"
#include "opencv2/highgui.hpp"
#include "opencv2/imgcodecs.hpp"
#include "opencv2/imgproc.hpp"
#include <opencv2/imgproc/imgproc.hpp>

namespace G
{

CvHistogramEqualization::CvHistogramEqualization()
    : Node("CvHistogramEqualization")
    , m_inPort(Port::TYPE::GIMAGE)
    , m_outPort(Port::TYPE::GIMAGE)
{
    registerPorts({&m_inPort}, {&m_outPort});
}

bool CvHistogramEqualization::retrieveResult()
{
    try
    {
        cv::Mat& cvImage = m_inPort.getGImage()->getCvMatImage();

        if (cvImage.channels() > 1)
        {
            cv::cvtColor(cvImage, cvImage, CV_BGR2GRAY);
        }

        cv::equalizeHist(cvImage, cvImage);

        m_outPort.getGImage()->setImage(cvImage);
    }
    catch (int e)
    {
        qDebug() << "CvHistogramEqualization. Exception Nr. " << e << '\n';
        return false;
    }

    return true;
}
} // namespace G
