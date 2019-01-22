#include "itkdiscretegaussianfilter.h"

#include "itkDiscreteGaussianImageFilter.h"
#include "itkMedianImageFilter.h"
#include "imageconverter.h"
#include <QDebug>

ItkDiscreteGaussianFilter::ItkDiscreteGaussianFilter()
{
    variance = 1.5;
}

void ItkDiscreteGaussianFilter::setVariance(const double value)
{
    if (value == variance)
        return;

    variance = value;
    cleanCache();
    emit varianceChanged();
}

bool ItkDiscreteGaussianFilter::retrieveResult()
{
    if (m_inNodes.size() > 0) {
        if(!(m_img.isNull())){
            return true;
        }

        try {
            m_img = m_inNodes[0]->getResult();
            //1. get the current image object
            QImage img = m_img.toImage();

            //2. Prepare ITK filter
            constexpr unsigned int imageDimension = 2;
            using ImageType = itk::Image<unsigned char, imageDimension>;

            //3. Convert QImage to ITK Image
            ImageType::Pointer imageIn = ImageType::New();
            ImageConverter::itkImageFromQImage(imageIn, img);

            //4. apply the filter
            using filterType = itk::DiscreteGaussianImageFilter<ImageType, ImageType >;

            filterType::Pointer gaussianFilter = filterType::New();
            gaussianFilter->SetInput(imageIn);
            gaussianFilter->SetVariance(variance);
            gaussianFilter->Update();

            imageIn = gaussianFilter->GetOutput();

            //5. convert to QImage
            ImageConverter::qImageFromITKImage(imageIn, img);

            //6. continue the flow
            m_img = QPixmap::fromImage(img);

        } catch (int e) {
            qDebug() << "ItkDiscreteGaussianFilter. Exception Nr. " << e << '\n';
            return false;
        }
    }
    return true;
}
