#include "gimage.h"


GImage::GImage()
{
    m_qPixmap =QPixmap();
    m_qImage = QImage();
    m_cvMatImage = cv::Mat();
    m_itkImage = nullptr;
}

GImage::~GImage()
{

}

void GImage::setImage(QPixmap qPixmap)
{
    m_qPixmap = qPixmap;
    m_qImage = QImage();
    m_cvMatImage = cv::Mat();
    m_itkImage = nullptr;
}

void GImage::setImage(QImage qImage)
{
    m_qImage = qImage;
    m_qPixmap = QPixmap();
    m_cvMatImage = cv::Mat();
    m_itkImage = nullptr;
}

void GImage::setImage(cv::Mat cvMatImage)
{
    m_cvMatImage = cvMatImage;
    m_qImage = QImage();
    m_qPixmap = QPixmap();
    m_itkImage = nullptr;
}

void GImage::setImage(const itkImageType::Pointer itkImage)
{
    m_itkImage = itkImage;

    m_qImage = QImage();
    m_qPixmap = QPixmap();
    m_cvMatImage = cv::Mat();
}

QPixmap GImage::getQPixmap()
{
    if(m_qPixmap.isNull()){
        if(!m_qImage.isNull()){
            m_qPixmap = ImageConverter::QImage2QPixmap(m_qImage);
        }
        else if(!m_cvMatImage.empty()){
            m_qImage = ImageConverter::Mat2QImage(m_cvMatImage);
            m_qPixmap = ImageConverter::QImage2QPixmap(m_qImage);
        }
        else if(!(m_itkImage == nullptr)){
            ImageConverter::qImageFromITKImage(m_itkImage, m_qImage);
            m_qPixmap = ImageConverter::QImage2QPixmap(m_qImage);
        }
    }

    return m_qPixmap;
}

QImage GImage::getQImage()
{
    if(m_qImage.isNull()){
        if(!m_qPixmap.isNull()){
            m_qImage = ImageConverter::QPixmap2QImage(m_qPixmap);
        }
        else if(!m_cvMatImage.empty()){
            m_qImage = ImageConverter::Mat2QImage(m_cvMatImage);
        }
        else {
            ImageConverter::qImageFromITKImage(m_itkImage, m_qImage);
        }
    }


    return m_qImage;
}

cv::Mat GImage::getCvMatImage()
{
    if(m_cvMatImage.empty()){
        if(!m_qImage.isNull()){
            m_cvMatImage = ImageConverter::QImage2Mat(m_qImage);
        }
        else if(!m_qPixmap.isNull()){
            m_qImage = ImageConverter::QPixmap2QImage(m_qPixmap);
            m_cvMatImage = ImageConverter::QImage2Mat(m_qImage);
        }
        else {
            ImageConverter::qImageFromITKImage(m_itkImage, m_qImage);
            m_cvMatImage = ImageConverter::QImage2Mat(m_qImage);
        }
    }

    return m_cvMatImage;
}

itk::Image<unsigned char, 2>::Pointer GImage::getItkImage()
{
    if(m_itkImage == nullptr) {
        m_itkImage = itkImageType::New();

        if(!m_qImage.isNull()){
            ImageConverter::itkImageFromQImage(m_itkImage, m_qImage);
        }
        else if(!m_qPixmap.isNull()){
            m_qImage = ImageConverter::QPixmap2QImage(m_qPixmap);
            ImageConverter::itkImageFromQImage(m_itkImage, m_qImage);
        }
        else {
            m_qImage = ImageConverter::Mat2QImage(m_cvMatImage);
            ImageConverter::itkImageFromQImage(m_itkImage, m_qImage);
        }
    }

    return m_itkImage;
}


bool GImage::isSet()
{
    if(m_qPixmap.isNull() && m_qImage.isNull() && m_cvMatImage.empty() && (m_itkImage == nullptr)){
        return false;
    }else {
        return true;
    }
}

GImage GImage::deepCopy()
{
    GImage result;

    if(!m_qPixmap.isNull()){
        result.setImage(this->qPixmapDeepCopy());
    }
    if(!m_qImage.isNull()){
        result.setImage(this->qImageDeepCopy());
    }
    if(!m_cvMatImage.empty()){
        result.setImage(this->cvMatDeepCopy());
    }
    if(m_itkImage != nullptr){
        result.setImage(this->itkDeepCopy());
    }

    return result;
}

QPixmap GImage::qPixmapDeepCopy()
{
    return m_qPixmap.copy();
}

QImage GImage::qImageDeepCopy()
{
    return m_qImage.copy();
}

cv::Mat GImage::cvMatDeepCopy()
{
    return m_cvMatImage.clone();
}

itk::Image<unsigned char, 2>::Pointer GImage::itkDeepCopy()
{
    // deep copy
    itkImageType::Pointer copy = itkImageType::New();
    copy->SetRegions(m_itkImage->GetLargestPossibleRegion());
    copy->Allocate();

    itk::ImageRegionConstIterator<itkImageType> inputIterator(m_itkImage, m_itkImage->GetLargestPossibleRegion());
    itk::ImageRegionIterator<itkImageType> outputIterator(copy, copy->GetLargestPossibleRegion());

    while (!inputIterator.IsAtEnd())
    {
        outputIterator.Set(inputIterator.Get());
        ++inputIterator;
        ++outputIterator;
    }

    return copy;
}
