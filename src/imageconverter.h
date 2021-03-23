#ifndef IMAGECONVERTER_H
#define IMAGECONVERTER_H

#include <itkImage.h>
#include <itkImageFileReader.h>
#include <itkImageFileWriter.h>
#include <itkRGBAPixel.h>
#include <itkOpenCVImageBridge.h>

#include <QPixmap>
#include "gimage.h"
#include <cv.h>

#include <QDebug>
#include <iostream>

class ImageConverter
{
public:
    explicit ImageConverter();

    typedef itk::Image<unsigned char, 2> ItkImageType;
    // QPixmap
    static QImage QPixmap2QImage(QPixmap &src);

    // QImage
    static QPixmap QImage2QPixmap(QImage const& src);
    static cv::Mat QImage2CvMat(QImage const& src);
    template<typename TImage>
    static void QImage2ItkImage(TImage& image, const QImage& path);

    // CvMat
    static QImage CvMat2QImage(cv::Mat &src);
    static ItkImageType::Pointer CvMat2ItkImage(cv::Mat src);

    // ImageType Helper
    static QString cvType2String(int type);


    //ItkImage
    template<typename TImage>
    static void ItkImage2QImage(TImage& image, QImage& qImage);
//    template<typename TImage>
//    static cv::Mat ItkImage2Mat(TImage& image);
    static cv::Mat ItkImage2CvMat(ItkImageType::Pointer src);

    /*
    using RGBAPixelType = itk::RGBAPixel<unsigned char>;
    using RGBAImageType = itk::Image< RGBAPixelType , imageDimension>;
    */

/*
 * Deklaration der Template Funktionen zur Umwandlung von QImage
 * zur ITK / OpenCV Images (Farbbilder)
 *
 *
    template<typename TImage>
    static void itkImageFromQImage_RGBA(TImage& image, const QImage& path);

    template<typename TImage>
    static void qImageFromITKImage_RGBA(TImage& image, QImage& qImage);
*/

};

//template<typename TImage>
//cv::Mat ImageConverter::ItkImage2Mat(TImage &image)
//{
//    return itk::OpenCVImageBridge::ITKImageToCVMat<TImage>(image, true);
//}

template <typename TImage>
void ImageConverter::QImage2ItkImage(TImage& image, const QImage& qImage)
{
    ItkImageType::RegionType region;
    ItkImageType::IndexType start;
    ItkImageType::SizeType size;

    start[0] = 0;
    start[1] = 0;

    size[0] = qImage.width();
    size[1] = qImage.height();

    region.SetSize(size);
    region.SetIndex(start);

    image->SetRegions(region);
    image->Allocate();

    for(int w = 0; w < qImage.width(); w++)
    {
        for(int h = 0; h < qImage.height(); h++)
        {
            ItkImageType::IndexType pixelIndex;
            pixelIndex[0] = w;
            pixelIndex[1] = h;
            image->SetPixel(pixelIndex, qImage.pixel(w,h));
        }
    }

}

template <typename TImage>
void ImageConverter::ItkImage2QImage(TImage& image, QImage &qImage)
{
    ItkImageType::RegionType region = image->GetLargestPossibleRegion();
    int width = (int)region.GetSize(0);
    int height = (int)region.GetSize(1);

    QImage qimageOut(width, height, QImage::QImage::Format_Grayscale8); //Bilder Schwarzweiss wegen Format

    for(int w = 0; w < width; w++)
    {
        for(int h = 0; h < height; h++)
        {
            ItkImageType::IndexType pixelIndex = {{w,h}};
            ItkImageType::PixelType pixelValue = image->GetPixel( pixelIndex );
            QRgb value = qRgb(pixelValue, pixelValue, pixelValue); // Pixelwerte aus der ITK Image in einzelnen channels gleich
            qimageOut.setPixel(w, h, value);
        }
    }
    qImage = qimageOut;
}

/*

template <typename TImage>
void ImageConverter::itkImageFromQImage_RGBA(TImage& image, const QImage& qImage)
{
    RGBAImageType::RegionType region;
    RGBAImageType::IndexType  start;
    RGBAImageType::SizeType   size;
    RGBAImageType::IndexType  pixelIndex;
    RGBAPixelType pixelValue;

    RGBAImageType::Pointer itkImageIn = RGBAImageType::New();

    start[0] = 0;
    start[1] = 0;

    size[0] = qImage.width();
    size[1] = qImage.height();

    region.SetSize(size);
    region.SetIndex(start);

    itkImageIn->SetRegions(region);
    itkImageIn->Allocate();

    for(int w = 0; w < qImage.width(); w++)
    {
        for(int h = 0; h < qImage.height(); h++)
        {
              QColor pixelColor(qImage.pixel(w, h));

              pixelValue.SetRed(pixelColor.red());
              pixelValue.SetGreen(pixelColor.green());
              pixelValue.SetBlue(pixelColor.blue());
              pixelValue.SetAlpha(pixelColor.alpha());

              pixelIndex[0] = w;
              pixelIndex[1] = h;

              itkImageIn->SetPixel(pixelIndex, pixelValue);
        }
    }
    image = itkImageIn;
}

template <typename TImage>
void ImageConverter::qImageFromITKImage_RGBA(TImage& image, QImage &qImage)
{
    QImage qimageOut(qImage.width(), qImage.height(), QImage::Format_RGBA8888);

    for(int w = 0; w < qImage.width(); w++)
    {
        for(int h = 0; h < qImage.height(); h++)
        {
            RGBAImageType::IndexType pixelIndex = {{w,h}};
            RGBAImageType::PixelType pixelValue = image->GetPixel( pixelIndex );

            int red      = pixelValue.GetRed();
            int green    = pixelValue.GetGreen();
            int blue     = pixelValue.GetBlue();
            int alpha    = pixelValue.GetAlpha();

            QRgb value = qRgba(red, green, blue, alpha);
            qimageOut.setPixel(w, h, value);
        }
    }
    qImage = qimageOut;   
}
*/

#endif // IMAGECONVERTER_H
