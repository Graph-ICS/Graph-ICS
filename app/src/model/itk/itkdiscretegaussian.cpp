#include "itkdiscretegaussian.h"

#include "itkDiscreteGaussianImageFilter.h"
#include "itkMedianImageFilter.h"

#include <QDebug>

namespace G
{

ItkDiscreteGaussian::ItkDiscreteGaussian()
    : Node("ItkDiscreteGaussian")
    , m_inPort(Port::TYPE::GIMAGE)
    , m_outPort(Port::TYPE::GIMAGE)
    , m_variance(attributeFactory.makeIntTextField(1, 0, 50, 1, "Variance"))
{
    registerPorts({&m_inPort}, {&m_outPort});
    registerAttribute("variance", m_variance);
}

bool ItkDiscreteGaussian::retrieveResult()
{
    try
    {
        constexpr unsigned int imageDimension = 2;
        using ImageType = itk::Image<unsigned char, imageDimension>;

        itk::Image<unsigned char, 2>::Pointer& itkImage = m_inPort.getGImage()->getItkImage();

        using filterType = itk::DiscreteGaussianImageFilter<ImageType, ImageType>;

        filterType::Pointer gaussianFilter = filterType::New();
        gaussianFilter->SetInput(itkImage);
        gaussianFilter->SetVariance(m_variance->getValue().toInt());
        gaussianFilter->Update();

        itkImage = gaussianFilter->GetOutput();

        m_outPort.getGImage()->setImage(itkImage);
    }
    catch (int e)
    {
        qDebug() << "ItkDiscreteGaussian. Exception Nr. " << e << '\n';
        return false;
    }

    return true;
}
} // namespace G
