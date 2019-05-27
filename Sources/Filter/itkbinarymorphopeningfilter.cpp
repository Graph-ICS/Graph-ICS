#include "itkbinarymorphopeningfilter.h"

#include "itkBinaryMorphologicalOpeningImageFilter.h"
#include "itkBinaryBallStructuringElement.h"

#include "imageconverter.h"
#include <QDebug>

ItkBinaryMorphOpeningFilter::ItkBinaryMorphOpeningFilter()
{
    radius = 1.5;
}

void ItkBinaryMorphOpeningFilter::setRadius(const double value)
{
    if (value == radius)
        return;

    radius = value;
    cleanCache();
    emit radiusChanged();

}

bool ItkBinaryMorphOpeningFilter::retrieveResult()
{
    if (m_inNodes.size() < 1) {
        return false;
    }
    else {
        try {
            m_img = m_inNodes[0]->getResult();
            //1. get the current image object
            QImage img = m_img.toImage();

            //2. Prepare ITK filter
            const int imageDimension = 2;
            using ImageType = itk::Image< unsigned char, imageDimension >;

            //3. Convert QImage to ITK Image
            ImageType::Pointer imageIn = ImageType::New();
            ImageConverter::itkImageFromQImage(imageIn, img);

            //4. apply the filter
            typedef itk::BinaryBallStructuringElement<ImageType::PixelType, ImageType::ImageDimension > StructuringElementType;
            StructuringElementType structuringElement;
            structuringElement.SetRadius(radius);
            structuringElement.CreateStructuringElement();

            typedef itk::BinaryMorphologicalOpeningImageFilter <ImageType,
                    ImageType,
                    StructuringElementType> BinaryMorphologicalOpeningImageFilter;

            BinaryMorphologicalOpeningImageFilter::Pointer openingFilter =
                    BinaryMorphologicalOpeningImageFilter::New();

            openingFilter->SetInput(imageIn);
            openingFilter->SetKernel(structuringElement);
            openingFilter->Update();

            imageIn = openingFilter->GetOutput();

            //5. convert to QImage
            ImageConverter::qImageFromITKImage(imageIn, img);
            //6. continue the flow
            m_img = QPixmap::fromImage(img);

        } catch (int e) {
            qDebug() << "ItkBinaryMorphOpeningFilter. Exception Nr. " << e << '\n';
            return false;
        }
    }
    return true;
}
