#include "itkbinarymorphclosing.h"

#include "itkBinaryBallStructuringElement.h"
#include "itkBinaryMorphologicalClosingImageFilter.h"

#include <QDebug>

namespace G
{

ItkBinaryMorphClosing::ItkBinaryMorphClosing()
    : Node("ItkBinaryMorphClosing")
    , m_inPort(Port::TYPE::GIMAGE)
    , m_outPort(Port::TYPE::GIMAGE)
    , m_radius(attributeFactory.makeIntTextField(1, 0, 100, 1, "Radius"))
{
    registerPorts({&m_inPort}, {&m_outPort});
    registerAttribute("radius", m_radius);
}

bool ItkBinaryMorphClosing::retrieveResult()
{
    try
    {

        const int imageDimension = 2;
        using ImageType = itk::Image<unsigned char, imageDimension>;

        ImageType::Pointer& itkImage = m_inPort.getGImage()->getItkImage();

        typedef itk::BinaryBallStructuringElement<ImageType::PixelType, ImageType::ImageDimension>
            StructuringElementType;

        StructuringElementType structuringElement;
        structuringElement.SetRadius(m_radius->getValue().toInt());
        structuringElement.CreateStructuringElement();

        typedef itk::BinaryMorphologicalClosingImageFilter<ImageType, ImageType, StructuringElementType>
            BinaryMorphologicalClosingImageFilterType;

        BinaryMorphologicalClosingImageFilterType::Pointer closingFilter =
            BinaryMorphologicalClosingImageFilterType::New();

        closingFilter->SetInput(itkImage);
        closingFilter->SetKernel(structuringElement);
        closingFilter->Update();

        itkImage = closingFilter->GetOutput();

        m_outPort.getGImage()->setImage(itkImage);
    }
    catch (int e)
    {
        qDebug() << "ItkBinaryMorphClosing. Exception Nr. " << e << '\n';
        return false;
    }

    return true;
}
} // namespace G
