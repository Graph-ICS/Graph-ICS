#include "imageconverter.h"
#include <opencv2/opencv.hpp>

#include <opencv2/highgui/highgui.hpp>  //namedWindow, imshow, waitKey
#include <opencv2/core/core.hpp>

ImageConverter::ImageConverter()
{

}

void ImageConverter::cvImageFromQImage(cv::Mat& cvImage, const QImage& qImage){

    cvImage = cv::Mat::zeros(qImage.height(), qImage.width(), CV_8U); //fails with CV_8UC4 , format benutzen für RGBA BIlder
    for( int i = 0; i < cvImage.rows; ++i)
    {
        for ( int j = 0; j < cvImage.cols; ++j)
            cvImage.at<char>(i,j) = qImage.pixel(j,i);  //int fails
    }
}

void ImageConverter::qImageFromCvImage(const cv::Mat& cvImage, QImage& qImage){

    for( int i = 0; i < cvImage.rows; ++i)
    {
        for ( int j = 0; j < cvImage.cols; ++j)
        {
            auto pixelValue = cvImage.at<char>(i,j);
            QRgb value = qRgb(pixelValue, pixelValue, pixelValue); /// RGBA Werte sollen hier angepasst werden
            qImage.setPixel(j, i, value);
        }
    }
}


