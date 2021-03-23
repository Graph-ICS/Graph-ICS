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

    typedef itk::Image<unsigned char, 2> ItkImageType;

    void setImage(QPixmap qPixmap);
    void setImage(QImage qImage);
    void setImage(cv::Mat cvMatImage);
    void setImage(ItkImageType::Pointer itkImage);

    QPixmap getQPixmap();
    QImage getQImage();
    cv::Mat getCvMatImage();
    ItkImageType::Pointer getItkImage();

    GImage deepCopy();

    bool isEmpty();
    void clear();

private:
    QPixmap m_qPixmap;
    QImage m_qImage;
    cv::Mat m_cvMatImage;
    ItkImageType::Pointer m_itkImage;

    QPixmap qPixmapDeepCopy();
    QImage qImageDeepCopy();
    cv::Mat cvMatDeepCopy();
    ItkImageType::Pointer itkDeepCopy();

};


#endif // GIMAGE_H
