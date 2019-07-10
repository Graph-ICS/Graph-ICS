#include "cvmedianfilter.h"

#include <cv.h>
#include <opencv2/imgproc/imgproc.hpp>

#include "imageconverter.h"
#include <QDebug>

CvMedianFilter::CvMedianFilter()
{
    m_kernelSize = 1;
}

int CvMedianFilter::getKernelSize() const
{
    return m_kernelSize;
}

void CvMedianFilter::setKernelSize(int value)
{
    if (value == m_kernelSize)
        return;

    m_kernelSize = value;
    cleanCache();
    emit kernelSizeChanged();
}

bool CvMedianFilter::retrieveResult()
{
    if (m_inNodes.size() < 1) {
        return false;
    }
    else {
        try {
            m_img = m_inNodes[0]->getResult();

            //1. get the current image object
            QImage img = m_img.toImage();

            //2. Prepare OpenCv filter
            cv::Mat cvImage;// = qimage_to_mat_ref(img, CV_8U);

            //3. Convert QImage to OpenCv Image
            ImageConverter::cvImageFromQImage(cvImage, img);

            //4. apply the filter
            //4.1 set values
            // Median smoothing
            cv::medianBlur( cvImage, cvImage, m_kernelSize);

            //5. convert to QImage
            ImageConverter::qImageFromCvImage(cvImage, img);

            //6. continue the flow
            m_img = QPixmap::fromImage(img);

        } catch (int e) {
            qDebug() << "CvSobelOperatorFilter. Exception Nr. " << e << '\n';
            return false;
        }
    }
    return true;
}
