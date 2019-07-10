#include "itkbinarymorphclosingfilter.h"

#include "itkBinaryMorphologicalClosingImageFilter.h"
#include "itkBinaryBallStructuringElement.h"

#include "imageconverter.h"
#include <QDebug>

ItkBinaryMorphClosingFilter::ItkBinaryMorphClosingFilter()
{
    m_radius = 1.5;
}

double ItkBinaryMorphClosingFilter::getRadius()
{
    return m_radius;
}

void ItkBinaryMorphClosingFilter::setRadius(const double value)
{
    if (value == m_radius)
        return;

    m_radius = value;
    cleanCache();
    emit radiusChanged();

}

bool ItkBinaryMorphClosingFilter::retrieveResult()
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
            using ImageType = itk::Image< unsigned char,  imageDimension >;

            //3. Convert QImage to ITK Image
            ImageType::Pointer imageIn = ImageType::New();
            ImageConverter::itkImageFromQImage(imageIn, img);

            //4. apply the filter
            typedef itk::BinaryBallStructuringElement<ImageType::PixelType,
                                                      ImageType::ImageDimension > StructuringElementType;

            StructuringElementType structuringElement;
            structuringElement.SetRadius(m_radius);
            structuringElement.CreateStructuringElement();

            typedef itk::BinaryMorphologicalClosingImageFilter <ImageType,
                                                                ImageType,
                                                                StructuringElementType> BinaryMorphologicalClosingImageFilterType;

            BinaryMorphologicalClosingImageFilterType::Pointer closingFilter =
            BinaryMorphologicalClosingImageFilterType::New();

            closingFilter->SetInput(imageIn);
            closingFilter->SetKernel(structuringElement);
            closingFilter->Update();

            imageIn = closingFilter->GetOutput();

            //5. convert to QImage
            ImageConverter::qImageFromITKImage(imageIn, img);
            //6. continue the flow
            m_img = QPixmap::fromImage(img);

        } catch (int e) {
            qDebug() << "ItkBinaryMorphClosingFilter. Exception Nr. " << e << '\n';
            return false;
        }
    }
    return true;
}
