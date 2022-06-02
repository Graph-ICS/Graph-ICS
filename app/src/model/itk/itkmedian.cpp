#include "itkmedian.h"

#include <itkImage.h>
#include <itkMedianImageFilter.h>
#include <itkRGBPixel.h>

namespace G
{

ItkMedian::ItkMedian()
    : Node("ItkMedian")
    , m_inPort(Port::TYPE::GIMAGE)
    , m_outPort(Port::TYPE::GIMAGE)
    , m_radiusX(attributeFactory.makeIntTextField(1, 0, 50, 1, "x Radius"))
    , m_radiusY(attributeFactory.makeIntTextField(1, 0, 50, 1, "y Radius"))
{
    registerPorts({&m_inPort}, {&m_outPort});
    registerAttribute("radiusX", m_radiusX);
    registerAttribute("radiusY", m_radiusY);
}

bool ItkMedian::retrieveResult()
{
    try
    {
        constexpr unsigned int imageDimension = 2;
        using InputImageType = itk::Image<unsigned char, imageDimension>;
        using OutputImageType = itk::Image<unsigned char, imageDimension>;

        using FilterType = itk::MedianImageFilter<InputImageType, OutputImageType>;
        FilterType::Pointer filter = FilterType::New();

        InputImageType::SizeType indexRadius;
        indexRadius[0] = m_radiusX->getValue().toInt();
        indexRadius[1] = m_radiusY->getValue().toInt();
        filter->SetRadius(indexRadius);

        GImage::ItkImageType::Pointer& itkImage = m_inPort.getGImage()->getItkImage();

        filter->SetInput(itkImage);
        filter->Update();
        itkImage = filter->GetOutput();

        m_outPort.getGImage()->setImage(itkImage);
    }
    catch (int e)
    {
        qDebug() << "ItkMedian. Exception Nr. " << e << '\n';
        return false;
    }

    return true;
}
} // namespace G
