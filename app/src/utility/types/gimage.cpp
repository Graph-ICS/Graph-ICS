#include "gimage.h"

GImage::GImage()
    : m_QPixmap()
    , m_QImage()
    , m_CvMat()
    , m_ItkImage(nullptr)
{
    m_isCompressed = false;
}

GImage::~GImage()
{
}

void GImage::setImage(const QImage& qImage)
{
    clear();
    m_QImage = qImage;
}

void GImage::setImage(const cv::Mat& cvMatImage)
{
    clear();
    m_CvMat = cvMatImage;
}

void GImage::setImage(const ItkImageType::Pointer& itkImage)
{
    clear();
    m_ItkImage = itkImage;
}

QPixmap& GImage::getQPixmap()
{
    getQImage();
    if (m_QImage.isNull())
    {
        qDebug() << "get QPixmap failed: QImage is Null";
        m_QPixmap = QPixmap();
    }
    else
    {
        ImageConverter::QImageToQPixmap(m_QImage, m_QPixmap);
    }

    return m_QPixmap;
}

QImage& GImage::getQImage(QImage::Format format)
{
    if (m_isCompressed)
    {
        if (m_JpegImage.empty())
        {
            qDebug() << "get QImage failed: Compressed Image is empty";
            m_QImage = QImage();
        }
        else
        {
            ImageConverter::JpegImageToQImage(m_JpegImage, m_QImage);
        }
        m_isCompressed = false;
        m_JpegImage.clear();
    }
    else
    {
        if (m_QImage.isNull())
        {
            if (!m_CvMat.empty())
            {
                ImageConverter::CvMatToQImage(m_CvMat, m_QImage);
            }
            else if (m_ItkImage != nullptr)
            {
                ImageConverter::ItkImageToQImage(m_ItkImage, m_QImage);
            }
            else
            {
                qDebug() << "get QImage failed: All Images are empty!";
            }
        }
    }

    if (m_QImage.format() != format)
    {
        m_QImage.convertTo(format);
    }

    return m_QImage;
}

cv::Mat& GImage::getCvMatImage()
{
    if (m_isCompressed)
    {
        if (m_JpegImage.empty())
        {
            qDebug() << "get cv::Mat failed: Compressed Image is empty";
            m_CvMat.release();
            m_CvMat = cv::Mat();
        }
        else
        {
            ImageConverter::JpegImageToCvMat(m_JpegImage, m_CvMat);
        }
        m_isCompressed = false;
        m_JpegImage.clear();
    }
    else
    {
        if (m_CvMat.empty())
        {
            if (!m_QImage.isNull())
            {
                ImageConverter::QImageToCvMat(m_QImage, m_CvMat);
            }
            else if (m_ItkImage != nullptr)
            {
                ImageConverter::ItkImageToCvMat(m_ItkImage, m_CvMat);
            }
            else
            {
                qDebug() << "get cv::Mat failed: All Images are empty!";
            }
        }
    }

    return m_CvMat;
}

itk::Image<unsigned char, 2>::Pointer& GImage::getItkImage()
{
    if (m_isCompressed)
    {
        if (m_JpegImage.empty())
        {
            qDebug() << "get Itk Image failed: Compressed Image is empty";
            m_ItkImage = nullptr;
        }
        else
        {
            ImageConverter::JpegImageToItkImage(m_JpegImage, m_ItkImage);
        }
        m_isCompressed = false;
        m_JpegImage.clear();
    }
    else
    {
        if (m_ItkImage == nullptr)
        {
            if (!m_QImage.isNull())
            {
                ImageConverter::QImageToItkImage(m_QImage, m_ItkImage);
            }
            else if (!m_CvMat.empty())
            {
                ImageConverter::CvMatToItkImage(m_CvMat, m_ItkImage);
            }
            else
            {
                qDebug() << "get Itk Image failed: All Images are empty!";
            }
        }
    }

    return m_ItkImage;
}

GImage::Pointer GImage::getDeepCopy() const
{
    GImage::Pointer copy(new GImage());

    if (!m_QImage.isNull())
    {
        copy->setImage(this->QImageDeepCopy());
    }
    else if (!m_CvMat.empty())
    {
        copy->setImage(this->CvMatDeepCopy());
    }
    else if (m_ItkImage != nullptr)
    {
        copy->setImage(this->ItkImageDeepCopy());
    }
    else if (!m_JpegImage.empty())
    {
        copy->m_JpegImage = m_JpegImage;
        copy->m_isCompressed = true;
    }

    return copy;
}

bool GImage::isEmpty()
{
    return m_QImage.isNull() && m_CvMat.empty() && (m_ItkImage == nullptr) && m_JpegImage.empty();
}

void GImage::clear()
{
    m_QPixmap = QPixmap();
    m_QImage = QImage();
    m_CvMat.release();
    m_CvMat = cv::Mat();
    m_ItkImage = nullptr;
    m_JpegImage.clear();
}

void GImage::compressToJpeg()
{
    m_JpegImage.clear();

    if (!m_QImage.isNull())
    {
        ImageConverter::QImageToJpegImage(m_QImage, m_JpegImage, 100);
    }
    else if (!m_CvMat.empty())
    {
        ImageConverter::CvMatToJpegImage(m_CvMat, m_JpegImage, 100);
    }
    else if (m_ItkImage != nullptr)
    {
        ImageConverter::ItkImageToJpegImage(m_ItkImage, m_JpegImage, 100);
    }

    m_isCompressed = true;

    m_QPixmap = QPixmap();
    m_QImage = QImage();
    m_CvMat.release();
    m_CvMat = cv::Mat();
    m_ItkImage = nullptr;
}

QImage GImage::QImageDeepCopy() const
{
    return m_QImage.copy();
}

cv::Mat GImage::CvMatDeepCopy() const
{
    return m_CvMat.clone();
}

GImage::ItkImageType::Pointer GImage::ItkImageDeepCopy() const
{
    // deep copy
    ItkImageType::Pointer copy = ItkImageType::New();
    copy->SetRegions(m_ItkImage->GetLargestPossibleRegion());
    copy->Allocate();

    itk::ImageRegionConstIterator<ItkImageType> inputIterator(m_ItkImage, m_ItkImage->GetLargestPossibleRegion());
    itk::ImageRegionIterator<ItkImageType> outputIterator(copy, copy->GetLargestPossibleRegion());

    while (!inputIterator.IsAtEnd())
    {
        outputIterator.Set(inputIterator.Get());
        ++inputIterator;
        ++outputIterator;
    }

    return copy;
}
