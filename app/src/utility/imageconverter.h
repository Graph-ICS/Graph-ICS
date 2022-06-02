#ifndef IMAGECONVERTER_H
#define IMAGECONVERTER_H

#include "itkImportImageFilter.h"
#include <itkImage.h>
#include <itkImageFileReader.h>
#include <itkImageFileWriter.h>
#include <itkOpenCVImageBridge.h>
#include <itkRGBAPixel.h>

#include "gimage.h"
#include <QPixmap>
#include <opencv2/opencv.hpp>

#include <QDebug>
#include <iostream>

/*!
 * \brief ImageConverter is a not instantiateable class with only static members, used for conversion between image
 * types
 */
class ImageConverter
{
public:
    ImageConverter(ImageConverter const&) = delete;
    void operator=(ImageConverter const&) = delete;

    typedef itk::Image<unsigned char, 2> ItkImageType;

    static QString cvTypeToString(int type);

    // to QPixmap
    static void QImageToQPixmap(QImage& src, QPixmap& dest);

    // to QImage
    static void CvMatToQImage(cv::Mat& src, QImage& dest);
    static void ItkImageToQImage(ItkImageType::Pointer& src, QImage& dest);
    static void JpegImageToQImage(std::vector<uchar>& src, QImage& dest);

    // to cv::Mat
    static void QImageToCvMat(QImage& src, cv::Mat& dest);
    static void ItkImageToCvMat(ItkImageType::Pointer& src, cv::Mat& dest);
    static void JpegImageToCvMat(std::vector<uchar>& src, cv::Mat& dest);

    // to ItkImage
    static void CvMatToItkImage(cv::Mat& src, ItkImageType::Pointer& dest);
    static void QImageToItkImage(QImage& src, ItkImageType::Pointer& dest);
    static void JpegImageToItkImage(std::vector<uchar>& src, ItkImageType::Pointer& dest);

    // to Jpeg Image
    static void CvMatToJpegImage(cv::Mat& src, std::vector<uchar>& dest, unsigned int quality);
    static void QImageToJpegImage(QImage& src, std::vector<uchar>& dest, unsigned int quality);
    static void ItkImageToJpegImage(ItkImageType::Pointer& src, std::vector<uchar>& dest, unsigned int quality);

private:
    ImageConverter();

    static void QImageToCvMat(QImage& src, cv::Mat& dest, int format);
    static void CvMatToQImage(cv::Mat& src, QImage& dest, QImage::Format format);
};

#endif // IMAGECONVERTER_H
