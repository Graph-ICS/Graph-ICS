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

void GImage::setImage(const ItkImageType::Pointer itkImage)
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
            m_qImage = ImageConverter::CvMat2QImage(m_cvMatImage);
            m_qPixmap = ImageConverter::QImage2QPixmap(m_qImage);
        }
        else if(!(m_itkImage == nullptr)){
            ImageConverter::ItkImage2QImage(m_itkImage, m_qImage);
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
            m_qImage = ImageConverter::CvMat2QImage(m_cvMatImage);
        }
        else {
            ImageConverter::ItkImage2QImage(m_itkImage, m_qImage);
        }
    }


    return m_qImage;
}

cv::Mat GImage::getCvMatImage()
{
    if(m_cvMatImage.empty()){
        if(!m_qImage.isNull()){
            m_cvMatImage = ImageConverter::QImage2CvMat(m_qImage);
        }
        else if(!m_qPixmap.isNull()){
            m_qImage = ImageConverter::QPixmap2QImage(m_qPixmap);
            m_cvMatImage = ImageConverter::QImage2CvMat(m_qImage);
        }
        else {
//            ImageConverter::ItkImage2QImage(m_itkImage, m_qImage);
//            m_cvMatImage = ImageConverter::QImage2Mat(m_qImage);
            m_cvMatImage = ImageConverter::ItkImage2CvMat(m_itkImage);
        }
    }
    return m_cvMatImage;
}

itk::Image<unsigned char, 2>::Pointer GImage::getItkImage()
{
    if(m_itkImage == nullptr) {
        m_itkImage = ItkImageType::New();

        if(!m_qImage.isNull()){
            ImageConverter::QImage2ItkImage(m_itkImage, m_qImage);
        }
        else if(!m_qPixmap.isNull()){
            m_qImage = ImageConverter::QPixmap2QImage(m_qPixmap);
            ImageConverter::QImage2ItkImage(m_itkImage, m_qImage);
        }
        else {
//            m_qImage = ImageConverter::CvMat2QImage(m_cvMatImage);
//            ImageConverter::QImage2ItkImage(m_itkImage, m_qImage);
            m_itkImage = ImageConverter::CvMat2ItkImage(m_cvMatImage);
        }
    }

    return m_itkImage;
}


bool GImage::isEmpty()
{
    if(m_qPixmap.isNull() && m_qImage.isNull() && m_cvMatImage.empty() && (m_itkImage == nullptr)){
        return true;
    }else {
        return false;
    }
}

void GImage::clear()
{
    m_qPixmap = QPixmap();
    m_qImage = QImage();
    m_cvMatImage = cv::Mat();
    m_itkImage = nullptr;
}

GImage GImage::deepCopy()
{
    GImage copy;

    if(!m_qPixmap.isNull()){
        copy.setImage(this->qPixmapDeepCopy());
    }
    if(!m_qImage.isNull()){
        copy.setImage(this->qImageDeepCopy());
    }
    if(!m_cvMatImage.empty()){
        copy.setImage(this->cvMatDeepCopy());
    }
    if(m_itkImage != nullptr){
        copy.setImage(this->itkDeepCopy());
    }

    return copy;
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

GImage::ItkImageType::Pointer GImage::itkDeepCopy()
{
    // deep copy
    ItkImageType::Pointer copy = ItkImageType::New();
    copy->SetRegions(m_itkImage->GetLargestPossibleRegion());
    copy->Allocate();

    itk::ImageRegionConstIterator<ItkImageType> inputIterator(m_itkImage, m_itkImage->GetLargestPossibleRegion());
    itk::ImageRegionIterator<ItkImageType> outputIterator(copy, copy->GetLargestPossibleRegion());

    while (!inputIterator.IsAtEnd())
    {
        outputIterator.Set(inputIterator.Get());
        ++inputIterator;
        ++outputIterator;
    }

    return copy;
}
