#include "itkbinarymorphopening.h"

#include "itkBinaryBallStructuringElement.h"
#include "itkBinaryMorphologicalOpeningImageFilter.h"

#include "imageconverter.h"
#include <QDebug>

namespace G
{

ItkBinaryMorphOpening::ItkBinaryMorphOpening()
    : Node("ItkBinaryMorphOpening")
    , m_inPort(Port::TYPE::GIMAGE)
    , m_outPort(Port::TYPE::GIMAGE)
    , m_radius(attributeFactory.makeIntTextField(1, 0, 100, 1, "Radius"))
{
    registerPorts({&m_inPort}, {&m_outPort});
    registerAttribute("radius", m_radius);
}

bool ItkBinaryMorphOpening::retrieveResult()
{
    try
    {
        const int imageDimension = 2;
        using ImageType = itk::Image<unsigned char, imageDimension>;

        itk::Image<unsigned char, 2>::Pointer& itkImage = m_inPort.getGImage()->getItkImage();

        typedef itk::BinaryBallStructuringElement<ImageType::PixelType, ImageType::ImageDimension>
            StructuringElementType;
        StructuringElementType structuringElement;
        structuringElement.SetRadius(m_radius->getValue().toInt());
        structuringElement.CreateStructuringElement();

        typedef itk::BinaryMorphologicalOpeningImageFilter<ImageType, ImageType, StructuringElementType>
            BinaryMorphologicalOpeningImageFilter;

        BinaryMorphologicalOpeningImageFilter::Pointer openingFilter = BinaryMorphologicalOpeningImageFilter::New();

        openingFilter->SetInput(itkImage);
        openingFilter->SetKernel(structuringElement);
        openingFilter->Update();

        itkImage = openingFilter->GetOutput();

        m_outPort.getGImage()->setImage(itkImage);
    }
    catch (int e)
    {
        qDebug() << "ItkBinaryMorphOpening. Exception Nr. " << e << '\n';
        return false;
    }

    return true;
}
} // namespace G
