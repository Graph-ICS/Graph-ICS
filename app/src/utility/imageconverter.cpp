#include "imageconverter.h"

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>

#include <QBuffer>
#include <QImageReader>

#include <itkJPEGImageIO.h>

QString ImageConverter::cvTypeToString(int type)
{
    QString r;

    uchar depth = type & CV_MAT_DEPTH_MASK;
    uchar chans = 1 + (type >> CV_CN_SHIFT);

    switch (depth)
    {
        case CV_8U:
            r = "8U";
            break;
        case CV_8S:
            r = "8S";
            break;
        case CV_16U:
            r = "16U";
            break;
        case CV_16S:
            r = "16S";
            break;
        case CV_32S:
            r = "32S";
            break;
        case CV_32F:
            r = "32F";
            break;
        case CV_64F:
            r = "64F";
            break;
        default:
            r = "User";
            break;
    }

    r += "C";
    r += (chans + '0');

    qDebug() << "cv::Mat Type: " << r;

    return r;
}

void ImageConverter::QImageToQPixmap(QImage& src, QPixmap& dest)
{
    if (src.isNull())
    {
        qDebug() << "QImage to QPixmap failed: QImage is null";
        return;
    }
    dest = QPixmap::fromImage(src);
}

void ImageConverter::CvMatToQImage(cv::Mat& src, QImage& dest)
{
    if (src.empty())
    {
        qDebug() << "cv::Mat to QImage failed: cv::Mat is empty";
        return;
    }

    switch (src.type())
    {
        case CV_8UC3: {
            CvMatToQImage(src, dest, QImage::Format_RGB888);
            dest = dest.rgbSwapped();
            break;
        }
        case CV_8U: {
            CvMatToQImage(src, dest, QImage::Format_Indexed8);
            break;
        }
        case CV_8UC4: {
            CvMatToQImage(src, dest, QImage::Format_ARGB32);
            break;
        }
        default:
            qDebug() << "cv::Mat to QImage failed: Format " << cvTypeToString(src.type()) << " not supported";
            break;
    }
}

void ImageConverter::ItkImageToQImage(ItkImageType::Pointer& src, QImage& dest)
{
    if (src == nullptr)
    {
        qDebug() << "Itk Image to QImage failed: Itk Image is nullptr";
        return;
    }
    ItkImageType::RegionType region = src->GetLargestPossibleRegion();
    int width = (int)region.GetSize(0);
    int height = (int)region.GetSize(1);

    dest = QImage(src->GetBufferPointer(), width, height, QImage::Format_Indexed8);
}

void ImageConverter::JpegImageToQImage(std::vector<uchar>& src, QImage& dest)
{
    if (src.empty())
    {
        qDebug() << "Jpeg to QImage Image failed: Jpeg Image is empty";
        return;
    }
    QByteArray bytes = QByteArray::fromRawData(reinterpret_cast<const char*>(src.data()), src.size());
    QBuffer buffer(&bytes);
    QImageReader reader(&buffer);
    dest = reader.read();
}

void ImageConverter::QImageToCvMat(QImage& src, cv::Mat& dest)
{
    if (src.isNull())
    {
        qDebug() << "QImage to cv::Mat failed: QImage is null";
        return;
    }

    switch (src.format())
    {
        case QImage::Format_RGB888: {
            QImageToCvMat(src, dest, CV_8UC3);
            cv::cvtColor(dest, dest, CV_RGB2BGR);
            break;
        }
        case QImage::Format_Grayscale8:
        case QImage::Format_Indexed8: {
            QImageToCvMat(src, dest, CV_8U);
            break;
        }
        case QImage::Format_RGB32:
        case QImage::Format_ARGB32:
        case QImage::Format_ARGB32_Premultiplied: {
            QImageToCvMat(src, dest, CV_8UC4);
            break;
        }
        default:
            qDebug() << "QImage to cv::Mat failed: Format " << src.format() << " not supported!";
            break;
    }
}

void ImageConverter::ItkImageToCvMat(ItkImageType::Pointer& src, cv::Mat& dest)
{
    if (src == nullptr)
    {
        qDebug() << "Itk Image to cv::Mat failed: Itk Image is nullptr";
        return;
    }
    dest = itk::OpenCVImageBridge::ITKImageToCVMat<ItkImageType>(src, true);
}

void ImageConverter::JpegImageToCvMat(std::vector<uchar>& src, cv::Mat& dest)
{
    if (src.empty())
    {
        qDebug() << "Jpeg to cv::Mat Image failed: Jpeg Image is empty";
        return;
    }
    cv::imdecode(src, cv::ImreadModes::IMREAD_COLOR, &dest);
}

void ImageConverter::CvMatToItkImage(cv::Mat& src, ItkImageType::Pointer& dest)
{
    if (src.empty())
    {
        qDebug() << "cv::Mat to Itk Image failed: cv::Mat is empty!";
        return;
    }
    using ImageType = ItkImageType;
    IplImage temp = cvIplImage(src);
    dest = itk::OpenCVImageBridge::IplImageToITKImage<ImageType>(&temp);
}

void ImageConverter::QImageToItkImage(QImage& src, ItkImageType::Pointer& dest)
{
    std::vector<uchar> temp;
    QImageToJpegImage(src, temp, 100);
    JpegImageToItkImage(temp, dest);

    // Not working properly and slow!!!11

    //    if (src.isNull())
    //    {
    //        qDebug() << "QImage to Itk Image failed: QImage is null";
    //        return;
    //    }
    //    dest = ItkImageType::New();
    //    ItkImageType::RegionType region;
    //    ItkImageType::IndexType start;
    //    ItkImageType::SizeType size;

    //    start[0] = 0;
    //    start[1] = 0;

    //    size[0] = src.width();
    //    size[1] = src.height();

    //    region.SetSize(size);
    //    region.SetIndex(start);

    //    dest->SetRegions(region);
    //    dest->Allocate();

    //    for (int w = 0; w < src.width(); w++)
    //    {
    //        for (int h = 0; h < src.height(); h++)
    //        {
    //            ItkImageType::IndexType pixelIndex;
    //            pixelIndex[0] = w;
    //            pixelIndex[1] = h;
    //            dest->SetPixel(pixelIndex, src.pixel(w, h));
    //        }
    //    }
}

void ImageConverter::JpegImageToItkImage(std::vector<uchar>& src, ItkImageType::Pointer& dest)
{
    if (src.empty())
    {
        qDebug() << "Jpeg to Itk Image failed: Jpeg Image is empty";
        return;
    }
    cv::Mat mat;
    ImageConverter::JpegImageToCvMat(src, mat);
    dest = ItkImageType::New();
    ImageConverter::CvMatToItkImage(mat, dest);
}

void ImageConverter::CvMatToJpegImage(cv::Mat& src, std::vector<uchar>& dest, unsigned int quality)
{
    if (src.empty())
    {
        qDebug() << "cv::Mat to Jpeg failed: cv::Mat is empty";
        return;
    }
    std::vector<int> encodeParams;
    encodeParams.push_back(cv::IMWRITE_JPEG_QUALITY);
    encodeParams.push_back(quality);
    encodeParams.push_back(cv::IMWRITE_JPEG_PROGRESSIVE);
    encodeParams.push_back(1);
    encodeParams.push_back(cv::IMWRITE_JPEG_OPTIMIZE);
    encodeParams.push_back(1);
    cv::imencode(".jpeg", src, dest, encodeParams);
}

void ImageConverter::QImageToJpegImage(QImage& src, std::vector<uchar>& dest, unsigned int quality)
{
    if (src.isNull())
    {
        qDebug() << "QImage to Jpeg failed: QImage is null";
        return;
    }
    QByteArray arr;
    QBuffer buffer(&arr);
    buffer.open(QIODevice::WriteOnly);
    src.save(&buffer, "JPG", quality);
    dest = std::vector<uchar>(buffer.data().begin(), buffer.data().end());
}

void ImageConverter::ItkImageToJpegImage(ItkImageType::Pointer& src, std::vector<uchar>& dest, unsigned int quality)
{
    if (src == nullptr)
    {
        qDebug() << "Itk Image to Jpeg failed: Itk Image is nullptr";
        return;
    }
    cv::Mat mat;
    ImageConverter::ItkImageToCvMat(src, mat);
    ImageConverter::CvMatToJpegImage(mat, dest, quality);
}

void ImageConverter::QImageToCvMat(QImage& src, cv::Mat& dest, int format)
{
    dest = cv::Mat(src.height(), src.width(), format, src.bits(), src.bytesPerLine());
}

void ImageConverter::CvMatToQImage(cv::Mat& src, QImage& dest, QImage::Format format)
{
    dest = QImage(src.data, src.cols, src.rows, src.step, format);
}
