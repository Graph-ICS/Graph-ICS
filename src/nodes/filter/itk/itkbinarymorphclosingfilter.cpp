#include "itkbinarymorphclosingfilter.h"

#include "itkBinaryMorphologicalClosingImageFilter.h"
#include "itkBinaryBallStructuringElement.h"

#include "imageconverter.h"
#include <QDebug>

ItkBinaryMorphClosingFilter::ItkBinaryMorphClosingFilter()
{
    registerAttribute("radius", new NodeIntAttribute(1,100));
    m_nodeName = "ItkBinaryMorphClosing";
}

bool ItkBinaryMorphClosingFilter::retrieveResult()
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

            const int imageDimension = 2;
            using ImageType = itk::Image< unsigned char,  imageDimension >;

            ImageType::Pointer itkImage = m_img.getItkImage();

            typedef itk::BinaryBallStructuringElement<ImageType::PixelType,
                                                      ImageType::ImageDimension > StructuringElementType;

            StructuringElementType structuringElement;
            structuringElement.SetRadius(getAttributeValue("radius").toInt());
            structuringElement.CreateStructuringElement();

            typedef itk::BinaryMorphologicalClosingImageFilter <ImageType,
                                                                ImageType,
                                                                StructuringElementType> BinaryMorphologicalClosingImageFilterType;

            BinaryMorphologicalClosingImageFilterType::Pointer closingFilter =
            BinaryMorphologicalClosingImageFilterType::New();

            closingFilter->SetInput(itkImage);
            closingFilter->SetKernel(structuringElement);
            closingFilter->Update();

            itkImage = closingFilter->GetOutput();

            m_img.setImage(itkImage);

        } catch (int e) {
            qDebug() << "ItkBinaryMorphClosingFilter. Exception Nr. " << e << '\n';
            return false;
        }
    }
    return true;
}
