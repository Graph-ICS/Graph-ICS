#include "itkdiscretegaussianfilter.h"

#include "itkDiscreteGaussianImageFilter.h"
#include "itkMedianImageFilter.h"
#include "imageconverter.h"
#include <QDebug>

ItkDiscreteGaussianFilter::ItkDiscreteGaussianFilter()
{
    registerAttribute("variance", new NodeIntAttribute(1, 50));
    m_nodeName = "ItkDiscreteGaussian";
}

bool ItkDiscreteGaussianFilter::retrieveResult()
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
            using ImageType = itk::Image<unsigned char, imageDimension>;



            itk::Image<unsigned char, 2>::Pointer itkImage = m_img.getItkImage();


            using filterType = itk::DiscreteGaussianImageFilter<ImageType, ImageType >;

            filterType::Pointer gaussianFilter = filterType::New();
            gaussianFilter->SetInput(itkImage);
            gaussianFilter->SetVariance(getAttributeValue("variance").toInt());
            gaussianFilter->Update();

            itkImage = gaussianFilter->GetOutput();


            m_img.setImage(itkImage);

        } catch (int e) {
            qDebug() << "ItkDiscreteGaussianFilter. Exception Nr. " << e << '\n';
            return false;
        }
    }
    return true;
}
