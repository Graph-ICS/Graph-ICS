#include "itkbinarymorphopeningfilter.h"

#include "itkBinaryMorphologicalOpeningImageFilter.h"
#include "itkBinaryBallStructuringElement.h"

#include "imageconverter.h"
#include <QDebug>

ItkBinaryMorphOpeningFilter::ItkBinaryMorphOpeningFilter()
{
    registerAttribute("radius", new NodeIntAttribute(1,100));
    m_nodeName = "ItkBinaryMorphOpening";
}

bool ItkBinaryMorphOpeningFilter::retrieveResult()
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
            using ImageType = itk::Image< unsigned char, imageDimension >;



            itk::Image<unsigned char, 2>::Pointer itkImage = m_img.getItkImage();


            typedef itk::BinaryBallStructuringElement<ImageType::PixelType, ImageType::ImageDimension > StructuringElementType;
            StructuringElementType structuringElement;
            structuringElement.SetRadius(getAttributeValue("radius").toInt());
            structuringElement.CreateStructuringElement();

            typedef itk::BinaryMorphologicalOpeningImageFilter <ImageType,
                    ImageType,
                    StructuringElementType> BinaryMorphologicalOpeningImageFilter;

            BinaryMorphologicalOpeningImageFilter::Pointer openingFilter =
                    BinaryMorphologicalOpeningImageFilter::New();

            openingFilter->SetInput(itkImage);
            openingFilter->SetKernel(structuringElement);
            openingFilter->Update();

            itkImage = openingFilter->GetOutput();


            m_img.setImage(itkImage);

        } catch (int e) {
            qDebug() << "ItkBinaryMorphOpeningFilter. Exception Nr. " << e << '\n';
            return false;
        }
    }
    return true;
}
