#include "cvfouriertransformpsd.h"

namespace G
{

// PSD: Power Spectrum Density
CvFourierTransformPSD::CvFourierTransformPSD()
    : Node("CvFourierTransformPSD")
    , m_inPort(Port::TYPE::GIMAGE)
    , m_outPort(Port::TYPE::GIMAGE)
    , m_isLogAmplitude(attributeFactory.makeSwitchAttribute(true, "Show Log Amplitude"))
{
    registerPorts({&m_inPort}, {&m_outPort});
    registerAttribute("logAmplitude", m_isLogAmplitude);
}

bool CvFourierTransformPSD::retrieveResult()
{
    try
    {
        cv::Mat& cvImage = m_inPort.getGImage()->getCvMatImage();

        if (cvImage.channels() > 1)
        {
            cv::cvtColor(cvImage, cvImage, CV_BGR2GRAY);
        }
        bool log = m_isLogAmplitude->getValue().toBool();
        // convert to float Matix
        cvImage.convertTo(cvImage, CV_32F);

        // Only even Images
        cv::Rect roi = cv::Rect(0, 0, cvImage.cols & -2, cvImage.rows & -2);
        cvImage = cvImage(roi);

        cv::Mat psdImg;
        calcPSD(cvImage, psdImg, log);
        fftshift(psdImg, psdImg);
        cv::normalize(psdImg, psdImg, 0, 255, cv::NORM_MINMAX);
        psdImg.convertTo(psdImg, CV_8U);

        // Equalize Histogram to encance contrast
        if (!log)
        {
            cv::equalizeHist(psdImg, psdImg);
        }

        m_outPort.getGImage()->setImage(psdImg);
    }
    catch (int e)
    {
        qDebug() << "CvFourierTransformPSD Exception Nr. " << e << '\n';
        return false;
    }

    return true;
}

void CvFourierTransformPSD::fftshift(const cv::Mat& inputImg, cv::Mat& outputImg)
{
    outputImg = inputImg.clone();
    int cx = outputImg.cols / 2;
    int cy = outputImg.rows / 2;
    cv::Mat q0(outputImg, cv::Rect(0, 0, cx, cy));
    cv::Mat q1(outputImg, cv::Rect(cx, 0, cx, cy));
    cv::Mat q2(outputImg, cv::Rect(0, cy, cx, cy));
    cv::Mat q3(outputImg, cv::Rect(cx, cy, cx, cy));
    cv::Mat tmp;
    q0.copyTo(tmp);
    q3.copyTo(q0);
    tmp.copyTo(q3);
    q1.copyTo(tmp);
    q2.copyTo(q1);
    tmp.copyTo(q2);
}

void CvFourierTransformPSD::calcPSD(const cv::Mat& inputImg, cv::Mat& outputImg, int flag)
{
    cv::Mat planes[2] = {cv::Mat_<float>(inputImg.clone()), cv::Mat::zeros(inputImg.size(), CV_32F)};
    cv::Mat complexI;
    cv::merge(planes, 2, complexI);
    cv::dft(complexI, complexI);
    cv::split(complexI, planes); // planes[0] = Re(DFT(I)), planes[1] = Im(DFT(I))
    planes[0].at<float>(0) = 0;
    planes[1].at<float>(0) = 0;
    // compute the PSD = sqrt(Re(DFT(I))^2 + Im(DFT(I))^2)^2
    cv::Mat imgPSD;
    cv::magnitude(planes[0], planes[1], imgPSD); // imgPSD = sqrt(Power spectrum density)
    cv::pow(imgPSD, 2, imgPSD);                  // it needs ^2 in order to get PSD
    outputImg = imgPSD;
    // logPSD = log(1 + PSD)
    if (flag)
    {
        cv::Mat imglogPSD;
        imglogPSD = imgPSD + cv::Scalar::all(1);
        cv::log(imglogPSD, imglogPSD);
        outputImg = imglogPSD;
    }
}
} // namespace G
