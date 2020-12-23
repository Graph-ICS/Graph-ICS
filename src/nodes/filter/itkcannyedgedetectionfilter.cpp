 #include "itkcannyedgedetectionfilter.h"
#include "itkCastImageFilter.h"
#include "itkRescaleIntensityImageFilter.h"
#include "itkCannyEdgeDetectionImageFilter.h"
#include "imageconverter.h"
#include <QDebug>

ItkCannyEdgeDetectionFilter::ItkCannyEdgeDetectionFilter()
{    
    registerAttribute("variance", new NodeIntAttribute(2, 50, 0));
    registerAttribute("upperThreshold", new NodeIntAttribute(0, 200));
    registerAttribute("lowerThreshold", new NodeIntAttribute(0, 200));

    m_nodeName = "ItkCannyEdgeDetection";
}

bool ItkCannyEdgeDetectionFilter::retrieveResult()
{
    if (m_inNodes.size() < 1) {
            return false;
        }
    else {
        try {
            m_img = m_inNodes[0]->getResult();
            if(!m_img.isSet()){
                return false;
            }

            constexpr unsigned int imageDimension = 2;
            using CharPixelType = unsigned char;
            using DoublePixelType = double;
            using CharImageType = itk::Image< CharPixelType, imageDimension >;
            using DoubleImageType = itk::Image< DoublePixelType,  imageDimension >;

            itk::Image<unsigned char, 2>::Pointer itkImage = m_img.getItkImage();

            using CastToDoublelFilterType = itk::CastImageFilter< CharImageType, DoubleImageType >;
            using CannyFilterType = itk::CannyEdgeDetectionImageFilter< DoubleImageType, DoubleImageType >;
            using RescaleFilterType = itk::RescaleIntensityImageFilter< DoubleImageType, CharImageType >;

            CastToDoublelFilterType::Pointer toDouble = CastToDoublelFilterType::New();
            CannyFilterType::Pointer      cannyFilter = CannyFilterType::New();
            RescaleFilterType::Pointer    rescale     = RescaleFilterType::New();

            toDouble->SetInput( itkImage );
            cannyFilter->SetInput( toDouble->GetOutput() );
            rescale->SetInput( cannyFilter->GetOutput() );
            rescale->Update();

            cannyFilter->SetVariance( getAttributeValue("variance").toInt());
            cannyFilter->SetUpperThreshold( getAttributeValue("upperThreshold").toInt());
            cannyFilter->SetLowerThreshold( getAttributeValue("lowerThreshold").toInt());
            cannyFilter->Update();
            rescale->Update();

            itkImage = rescale->GetOutput();


            m_img.setImage(itkImage);

        } catch (int e) {
            qDebug() << "ItkCannyEdgeDetectionFilter. Exception Nr. " << e << '\n';
            return false;
        }
    }
    return true;
}
