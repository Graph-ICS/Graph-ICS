#include "cverosion.h"
#include "opencv2/highgui.hpp"
#include "opencv2/imgproc.hpp"

namespace G
{

CvErosion::CvErosion()
    : Node("CvErosion")
    , m_inPort(Port::TYPE::GIMAGE)
    , m_outPort(Port::TYPE::GIMAGE)
    , m_elementList({"Rectangle", "Cross", "Ellipse"})
    , m_element(attributeFactory.makeComboBox(*m_elementList.begin(), m_elementList, "Element"))
    , m_kernelSize(attributeFactory.makeIntTextField(1, 0, 21, 1, "Kernel Size"))
{
    registerPorts({&m_inPort}, {&m_outPort});
    registerAttribute("element", m_element);
    registerAttribute("kernelSize", m_kernelSize);
}

bool CvErosion::retrieveResult()
{
    try
    {
        cv::Mat& cvImage = m_inPort.getGImage()->getCvMatImage();
        int kernel = m_kernelSize->getValue().toInt();
        int index = m_elementList.indexOf(m_element->getValue().toString());
        cv::Mat element =
            cv::getStructuringElement(index, cv::Size(2 * kernel + 1, 2 * kernel + 1), cv::Point(kernel, kernel));
        cv::erode(cvImage, cvImage, element);

        m_outPort.getGImage()->setImage(cvImage);
    }
    catch (int e)
    {
        qDebug() << "CvErosion. Exception Nr. " << e << '\n';
        return false;
    }

    return true;
}
} // namespace G
