#include "cvsobeloperator.h"

#include <opencv2/imgproc/imgproc.hpp>

namespace G
{

CvSobelOperator::CvSobelOperator()
    : Node("CvSobelOperator")
    , m_inPort(Port::TYPE::GIMAGE)
    , m_outPort(Port::TYPE::GIMAGE)
    , m_xDerivative(attributeFactory.makeIntTextField(1, 0, 2, 1, "x-Derivative"))
    , m_yDerivative(attributeFactory.makeIntTextField(0, 0, 2, 1, "y-Derivative"))
{
    registerPorts({&m_inPort}, {&m_outPort});
    registerAttribute("xDerivative", m_xDerivative);
    registerAttribute("yDerivative", m_yDerivative);
}

bool CvSobelOperator::retrieveResult()
{
    try
    {
        cv::Mat& cvImage = m_inPort.getGImage()->getCvMatImage();

        if (cvImage.channels() > 1)
        {
            cv::cvtColor(cvImage, cvImage, CV_BGR2GRAY);
        }

        cv::Sobel(cvImage, cvImage, CV_8U, m_xDerivative->getValue().toInt(), m_yDerivative->getValue().toInt());

        m_outPort.getGImage()->setImage(cvImage);
    }
    catch (int e)
    {
        qDebug() << "CvSobelOperator. Exception Nr. " << e << '\n';
        return false;
    }

    return true;
}

void CvSobelOperator::onAttributeValueChanged(Attribute* attribute)
{
    clearStreamCache();
    if (attribute->getValue().toInt() == 0)
    {
        Attribute* other;
        if (attribute == m_xDerivative)
        {
            other = m_yDerivative;
        }
        else
        {
            other = m_xDerivative;
        }
        if (other->getValue().toInt() == 0)
        {
            other->setValue(1);
        }
    }
}
} // namespace G
