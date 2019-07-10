#include "itkcannyedgedetectionfilter.h"
#include "itkCastImageFilter.h"
#include "itkRescaleIntensityImageFilter.h"
#include "itkCannyEdgeDetectionImageFilter.h"
#include "imageconverter.h"
#include <QDebug>

ItkCannyEdgeDetectionFilter::ItkCannyEdgeDetectionFilter()
{    
    m_variance = 2.0;
    m_upperThreshold = 0.0;
    m_lowerThreshold = 0.0;
}

double ItkCannyEdgeDetectionFilter::getVariance()
{
    return m_variance;
}

void ItkCannyEdgeDetectionFilter::setVariance(const double value)
{
    if (value == m_variance)
        return;

    m_variance = value;
    m_img = QPixmap();
    emit varianceChanged();
}

double ItkCannyEdgeDetectionFilter::getUpperThreshold() const
{
    return m_upperThreshold;
}

void ItkCannyEdgeDetectionFilter::setUpperThreshold(double value)
{
    if (value == m_upperThreshold)
        return;

    m_upperThreshold = value;
    m_img = QPixmap();
    emit upperThresholdChanged();
}

double ItkCannyEdgeDetectionFilter::getLowerThreshold() const
{
    return m_lowerThreshold;
}

void ItkCannyEdgeDetectionFilter::setLowerThreshold(double value)
{
    if (value == m_lowerThreshold)
        return;

    m_lowerThreshold = value;
    cleanCache();
    emit lowerThresholdChanged();
}

bool ItkCannyEdgeDetectionFilter::retrieveResult()
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
            /*
            constexpr unsigned int imageDimension = 2;
            using CharPixelType = unsigned char;
            using DoublePixelType = double;
            using CharImageType = itk::Image< CharPixelType, imageDimension >;
            using DoubleImageType = itk::Image< DoublePixelType,  imageDimension >;
            */
            constexpr unsigned int imageDimension = 2;
            using CharPixelType = unsigned char;
            using DoublePixelType = double;
            using CharImageType = itk::Image< CharPixelType, imageDimension >;
            using DoubleImageType = itk::Image< DoublePixelType,  imageDimension >;

            //3. Convert QImage to ITK Image
            CharImageType::Pointer imageIn = CharImageType::New();
            ImageConverter::itkImageFromQImage(imageIn, img);

            //4. apply the filter
            using CastToDoublelFilterType = itk::CastImageFilter< CharImageType, DoubleImageType >;
            using CannyFilterType = itk::CannyEdgeDetectionImageFilter< DoubleImageType, DoubleImageType >;
            using RescaleFilterType = itk::RescaleIntensityImageFilter< DoubleImageType, CharImageType >;

            CastToDoublelFilterType::Pointer toDouble = CastToDoublelFilterType::New();
            CannyFilterType::Pointer      cannyFilter = CannyFilterType::New();
            RescaleFilterType::Pointer    rescale     = RescaleFilterType::New();

            toDouble->SetInput( imageIn );
            cannyFilter->SetInput( toDouble->GetOutput() );
            rescale->SetInput( cannyFilter->GetOutput() );
            rescale->Update();

            cannyFilter->SetVariance( m_variance );
            cannyFilter->SetUpperThreshold( m_upperThreshold );
            cannyFilter->SetLowerThreshold( m_lowerThreshold );
            cannyFilter->Update();
            rescale->Update();

            imageIn = rescale->GetOutput();

            //5. convert to QImage
            ImageConverter::qImageFromITKImage(imageIn, img);
            //6. continue the flow
            m_img = QPixmap::fromImage(img);

        } catch (int e) {
            qDebug() << "ItkCannyEdgeDetectionFilter. Exception Nr. " << e << '\n';
            return false;
        }
    }
    return true;
}
