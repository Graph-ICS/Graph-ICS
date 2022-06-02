#ifndef GIMAGE_H
#define GIMAGE_H

#include "imageconverter.h"
#include "itkImage.h"
#include <QImage>
#include <QPixmap>
#include <opencv2/core/mat.hpp>

class GImage
{
public:
    GImage();
    ~GImage();

    typedef QSharedPointer<GImage> Pointer;

    typedef itk::Image<unsigned char, 2> ItkImageType;

    void setImage(const QImage& qImage);
    void setImage(const cv::Mat& cvMatImage);
    void setImage(const ItkImageType::Pointer& itkImage);

    QPixmap& getQPixmap();

    QImage& getQImage(QImage::Format format = QImage::Format_RGB888);
    cv::Mat& getCvMatImage();
    ItkImageType::Pointer& getItkImage();

    GImage::Pointer getDeepCopy() const;

    bool isEmpty();
    void clear();

    void compressToJpeg();

private:
    QPixmap m_QPixmap;

    QImage m_QImage;
    cv::Mat m_CvMat;
    ItkImageType::Pointer m_ItkImage;

    bool m_isCompressed;
    std::vector<uchar> m_JpegImage;

    QImage QImageDeepCopy() const;
    cv::Mat CvMatDeepCopy() const;
    ItkImageType::Pointer ItkImageDeepCopy() const;
};

#endif // GIMAGE_H
