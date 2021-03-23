#include "itkmedianfilter.h"
#include "imageconverter.h"

#include <itkMedianImageFilter.h>
#include <itkRGBPixel.h>
#include <itkImage.h>

#include <QDebug>
#include <QDir>

ItkMedianFilter::ItkMedianFilter()
{

    registerAttribute("radiusX", new NodeIntAttribute(1, 50, 0, 1));
    registerAttribute("radiusY", new NodeIntAttribute(1, 50));

    m_nodeName = "ItkMedian";
}

bool ItkMedianFilter::retrieveResult()
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

            constexpr unsigned int imageDimension = 2;
            using InputImageType = itk::Image<unsigned char, imageDimension>;
            using OutputImageType = itk::Image<unsigned char, imageDimension>;


            using FilterType = itk::MedianImageFilter<InputImageType, OutputImageType>;
            FilterType::Pointer filter = FilterType::New();

            InputImageType::SizeType indexRadius;
            indexRadius[0] = getAttributeValue("radiusX").toInt(); // radius along x
            indexRadius[1] = getAttributeValue("radiusY").toInt(); // radius along y
            filter->SetRadius( indexRadius );

           itk::Image<unsigned char, 2>::Pointer itkImage = m_img.getItkImage();

            filter->SetInput(itkImage);
            filter->Update();
            itkImage = filter->GetOutput();

            m_img.setImage(itkImage);

        } catch (int e) {
            qDebug() << "ItkMedianFilter. Exception Nr. " << e << '\n';
            return false;
        }
    }
    return true;
}
