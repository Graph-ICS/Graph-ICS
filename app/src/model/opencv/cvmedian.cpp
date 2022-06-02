#include "cvmedian.h"

#include <opencv2/imgproc/imgproc.hpp>

#include <QDebug>

namespace G
{

CvMedian::CvMedian()
    : Node("CvMedian")
    , m_inPort(Port::TYPE::GIMAGE)
    , m_outPort(Port::TYPE::GIMAGE)
    , m_kernelSize(attributeFactory.makeIntTextField(1, 1, 199, 2, "Kernel Size"))
{
    registerPorts({&m_inPort}, {&m_outPort});
    registerAttribute("kernelSize", m_kernelSize);
}

bool CvMedian::retrieveResult()
{
    try
    {
        cv::Mat& cvImage = m_inPort.getGImage()->getCvMatImage();

        if (cvImage.channels() == 1)
        {
            cv::cvtColor(cvImage, cvImage, CV_GRAY2BGR);
        }

        cv::medianBlur(cvImage, cvImage, m_kernelSize->getValue().toInt());

        m_outPort.getGImage()->setImage(cvImage);
    }
    catch (int e)
    {
        qDebug() << "CvMedian. Exception Nr. " << e << '\n';
        return false;
    }

    return true;
}
} // namespace G
