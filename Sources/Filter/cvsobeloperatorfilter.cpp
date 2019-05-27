#include "cvsobeloperatorfilter.h"

#include <cv.h>
#include <opencv2/imgproc/imgproc.hpp>

#include "imageconverter.h"
#include <QDebug>

CvSobelOperatorFilter::CvSobelOperatorFilter()
{
    xDerivative = 1;
    yDerivative = 0;
    ddepth = CV_8U; //unsigned 8bit/pixel  CV_8U
}

int CvSobelOperatorFilter::getXDerivative() const
{
    return xDerivative;
}

void CvSobelOperatorFilter::setXDerivative(int value)
{
    if (value == xDerivative)
        return;

    xDerivative = value;
    cleanCache();
    emit xDerivativeSizeChanged();
}

int CvSobelOperatorFilter::getYDerivative() const
{
    return yDerivative;
}

void CvSobelOperatorFilter::setYDerivative(int value)
{
    if (value == yDerivative)
        return;

    yDerivative = value;
    cleanCache();
    emit yDerivativeSizeChanged();
}

bool CvSobelOperatorFilter::retrieveResult()
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
            cv::Sobel(cvImage, cvImage, ddepth, xDerivative, yDerivative);

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
