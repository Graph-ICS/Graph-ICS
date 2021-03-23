#include "imageconverter.h"
#include <opencv2/opencv.hpp>

#include <opencv2/highgui/highgui.hpp>  //namedWindow, imshow, waitKey
#include <opencv2/core/core.hpp>

ImageConverter::ImageConverter()
{

}

QString ImageConverter::cvType2String(int type) {
    QString r;

    uchar depth = type & CV_MAT_DEPTH_MASK;
    uchar chans = 1 + (type >> CV_CN_SHIFT);

    switch ( depth ) {
        case CV_8U:  r = "8U"; break;
        case CV_8S:  r = "8S"; break;
        case CV_16U: r = "16U"; break;
        case CV_16S: r = "16S"; break;
        case CV_32S: r = "32S"; break;
        case CV_32F: r = "32F"; break;
        case CV_64F: r = "64F"; break;
        default:     r = "User"; break;
    }

    r += "C";
    r += (chans+'0');

    qDebug() << "cv::Mat Type: " << r;

    return r;
}

cv::Mat ImageConverter::ItkImage2CvMat(ItkImageType::Pointer src)
{
    return itk::OpenCVImageBridge::ITKImageToCVMat<ItkImageType>(src, true);
}

QImage ImageConverter::CvMat2QImage(cv::Mat & src)
{
    QImage::Format format=QImage::Format_Grayscale8;
        int bpp=src.channels();
        if(bpp==3)format=QImage::Format_RGB888;
        QImage img(src.cols,src.rows,format);
        uchar *sptr,*dptr;
        int linesize=src.cols*bpp;
        for(int y=0;y<src.rows;y++){
            sptr=src.ptr(y);
            dptr=img.scanLine(y);
            memcpy(dptr,sptr,linesize);
        }
        if(bpp==3)return img.rgbSwapped();
        return img;
}

ImageConverter::ItkImageType::Pointer ImageConverter::CvMat2ItkImage(cv::Mat src)
{
    using ImageType = ItkImageType;
    IplImage temp = cvIplImage(src);
    ImageType::Pointer image = ImageType::New();
    image = itk::OpenCVImageBridge::IplImageToITKImage<ImageType>(&temp);
    return image;
}


QImage ImageConverter::QPixmap2QImage(QPixmap &src)
{
    QImage img = src.toImage();
    return img;
}

QPixmap ImageConverter::QImage2QPixmap(const QImage &src)
{
    QPixmap img = QPixmap::fromImage(src);
    return img;
}

cv::Mat ImageConverter::QImage2CvMat(const QImage &src)
{
    cv::Mat result;
    // RGB32 -> 4 Kanaele in CV Mat (CV_8UC4) 4: Channels, je 8: bit -> 4*8 = 32 bit
    // QImage::Format_RGB32 bei .png und .jpg Bildern
    if(src.format() == QImage::Format_RGB32){

        cv::Mat tmp(src.height(), src.width(), CV_8UC4, const_cast<uchar*>(src.bits()), static_cast<size_t>(src.bytesPerLine()));
         // deep copy zur sicherheit + drop all-white alpha channel
        cvtColor(tmp, result, CV_RGBA2RGB);

    }else{

        cv::Mat tmp(src.height(), src.width(), CV_8UC1, (uchar*)src.bits(), src.bytesPerLine());
        cvtColor(tmp, result, CV_GRAY2RGB);
    }

    return result;
}
