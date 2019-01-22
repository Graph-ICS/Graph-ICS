#ifndef IMAGECONVERTER_H
#define IMAGECONVERTER_H

#include <itkImage.h>
#include <itkImageFileReader.h>
#include <itkImageFileWriter.h>
#include <itkRGBAPixel.h>

#include <QPixmap>

#include <cv.h>

#include <QDebug>
#include <iostream>

class ImageConverter
{
public:
    explicit ImageConverter();

    static void cvImageFromQImage(cv::Mat& I, const QImage& qimage);
    static void qImageFromCvImage(const cv::Mat& cvImage, QImage& qImage);

    static const int imageDimension = 2;
    /*
    using RGBAPixelType = itk::RGBAPixel<unsigned char>;
    using RGBAImageType = itk::Image< RGBAPixelType , imageDimension>;
    */
    using ImagePixelType = unsigned char;
    using ImageType = itk::Image< ImagePixelType, imageDimension >;

    template<typename TImage>
    static void itkImageFromQImage(TImage& image, const QImage& path);

    template<typename TImage>
    static void qImageFromITKImage(TImage& image, QImage& qImage);

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

template <typename TImage>
void ImageConverter::itkImageFromQImage(TImage& image, const QImage& qImage)
{
    ImageType::RegionType region;
    ImageType::IndexType start;
    ImageType::SizeType size;

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
            ImageType::IndexType pixelIndex;
            pixelIndex[0] = w;
            pixelIndex[1] = h;
            image->SetPixel(pixelIndex, qImage.pixel(w,h));
        }
    }
}

template <typename TImage>
void ImageConverter::qImageFromITKImage(TImage& image, QImage &qImage)
{
    QImage qimageOut(qImage.width(), qImage.height(), QImage::QImage::Format_Grayscale8); //Bilder Schwarzweiss wegen Format

    for(int w = 0; w < qImage.width(); w++)
    {
        for(int h = 0; h < qImage.height(); h++)
        {
            ImageType::IndexType pixelIndex = {{w,h}};
            ImageType::PixelType pixelValue = image->GetPixel( pixelIndex );
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
