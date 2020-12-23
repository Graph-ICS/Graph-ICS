#ifndef GIMAGE_H
#define GIMAGE_H

#include <QPixmap>
#include <QImage>
#include <opencv2/core/mat.hpp>
#include "itkImage.h"
#include "imageconverter.h"

class GImage
{
public:
    GImage();
    ~GImage();

    typedef std::unique_ptr<GImage> Pointer;

    using itkImageType = itk::Image<unsigned char, 2>;

    void setImage(QPixmap qPixmap);
    void setImage(QImage qImage);
    void setImage(cv::Mat cvMatImage);
    void setImage(itkImageType::Pointer itkImage);

    QPixmap getQPixmap();
    QImage getQImage();
    cv::Mat getCvMatImage();
    itkImageType::Pointer getItkImage();

    bool isSet();

    GImage deepCopy();

private:
    QPixmap m_qPixmap;
    QImage m_qImage;
    cv::Mat m_cvMatImage;
    itkImageType::Pointer m_itkImage;

    QPixmap qPixmapDeepCopy();
    QImage qImageDeepCopy();
    cv::Mat cvMatDeepCopy();
    itkImageType::Pointer itkDeepCopy();

};


#endif // GIMAGE_H
