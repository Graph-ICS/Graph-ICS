#include "itkmedianfilter.h"
#include "imageconverter.h"

#include <itkMedianImageFilter.h>

#include <QDebug>
#include <QDir>

ItkMedianFilter::ItkMedianFilter()
{
    m_radiusX = 1;
    m_radiusY = 1;
}

void ItkMedianFilter::setRadiusX(const double value)
{
    if (value == m_radiusX) {
        return;
    }
    m_radiusX = value;
    cleanCache();
    emit radiusXChanged();
}

void ItkMedianFilter::setRadiusY(const double value)
{
    if (value == m_radiusY)
        return;

    m_radiusY = value;
    cleanCache();
    emit radiusYChanged();
}

bool ItkMedianFilter::retrieveResult()
{
    if (m_inNodes.size() < 1) {
        return false;
    }
    else {
        try {
            m_img = m_inNodes[0]->getResult();
            QImage img = m_img.toImage();

            constexpr unsigned int imageDimension = 2;
            using InputImageType = itk::Image<unsigned char, imageDimension>;
            using OutputImageType = itk::Image<unsigned char, imageDimension>;

            InputImageType ::Pointer itkImageIn = InputImageType ::New();
            ImageConverter::itkImageFromQImage(itkImageIn, img);

            using FilterType = itk::MedianImageFilter< InputImageType, OutputImageType>;
            FilterType::Pointer filter = FilterType::New();

            InputImageType::SizeType indexRadius;
            indexRadius[0] = m_radiusX; // radius along x
            indexRadius[1] = m_radiusY; // radius along y
            filter->SetRadius( indexRadius );
            filter->SetInput( itkImageIn );
            filter->Update();

            itkImageIn = filter->GetOutput();

            ImageConverter::qImageFromITKImage(itkImageIn, img);

            m_img = QPixmap::fromImage(img);

        } catch (int e) {
            qDebug() << "ItkMedianFilter. Exception Nr. " << e << '\n';
            return false;
        }
    }
    return true;
}
