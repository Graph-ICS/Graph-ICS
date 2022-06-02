#include "itkcannyedgedetection.h"

#include "itkCannyEdgeDetectionImageFilter.h"
#include "itkCastImageFilter.h"
#include "itkRescaleIntensityImageFilter.h"

#include <QDebug>

namespace G
{

ItkCannyEdgeDetection::ItkCannyEdgeDetection()
    : Node("ItkCannyEdgeDetection")
    , m_inPort(Port::GIMAGE)
    , m_outPort(Port::GIMAGE)
    , m_variance(attributeFactory.makeIntTextField(2, 0, 50, 1, "Variance"))
    , m_upperThreshold(attributeFactory.makeIntTextField(0, 0, 200, 1, "Upper Threshold"))
    , m_lowerThreshold(attributeFactory.makeIntTextField(0, 0, 200, 1, "Lower Threshold"))
{
    registerPorts({&m_inPort}, {&m_outPort});
    registerAttribute("variance", m_variance);
    registerAttribute("upperThreshold", m_upperThreshold);
    registerAttribute("lowerThreshold", m_lowerThreshold);
}

bool ItkCannyEdgeDetection::retrieveResult()
{
    try
    {
        constexpr unsigned int imageDimension = 2;
        using CharPixelType = unsigned char;
        using DoublePixelType = double;
        using CharImageType = itk::Image<CharPixelType, imageDimension>;
        using DoubleImageType = itk::Image<DoublePixelType, imageDimension>;

        itk::Image<unsigned char, 2>::Pointer& itkImage = m_inPort.getGImage()->getItkImage();

        using CastToDoublelFilterType = itk::CastImageFilter<CharImageType, DoubleImageType>;
        using CannyFilterType = itk::CannyEdgeDetectionImageFilter<DoubleImageType, DoubleImageType>;
        using RescaleFilterType = itk::RescaleIntensityImageFilter<DoubleImageType, CharImageType>;

        CastToDoublelFilterType::Pointer toDouble = CastToDoublelFilterType::New();
        CannyFilterType::Pointer cannyFilter = CannyFilterType::New();
        RescaleFilterType::Pointer rescale = RescaleFilterType::New();

        toDouble->SetInput(itkImage);
        cannyFilter->SetInput(toDouble->GetOutput());
        rescale->SetInput(cannyFilter->GetOutput());
        rescale->Update();

        cannyFilter->SetVariance(m_variance->getValue().toInt());
        cannyFilter->SetUpperThreshold(m_upperThreshold->getValue().toInt());
        cannyFilter->SetLowerThreshold(m_lowerThreshold->getValue().toInt());
        cannyFilter->Update();
        rescale->Update();

        itkImage = rescale->GetOutput();

        m_outPort.getGImage()->setImage(itkImage);
    }
    catch (int e)
    {
        qDebug() << "ItkCannyEdgeDetection. Exception Nr. " << e << '\n';
        return false;
    }

    return true;
}
} // namespace G
