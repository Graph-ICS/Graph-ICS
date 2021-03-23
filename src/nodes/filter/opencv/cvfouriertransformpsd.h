#ifndef CVFOURIERTRANSFORMPSD_H
#define CVFOURIERTRANSFORMPSD_H

#include <node.h>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/imgproc.hpp>

class CvFourierTransformPSD : public Node
{
public:
    CvFourierTransformPSD();
    bool retrieveResult();

private:
    void fftshift(const cv::Mat& inputImg, cv::Mat& outputImg);
    void calcPSD(const cv::Mat& inputImg, cv::Mat& outputImg, int flag);
};

#endif // CVFOURIERTRANSFORMPSD_H
