#include "sobel.hpp"

#include <iostream>

#include <cv.h>
#include <opencv2/imgproc/imgproc.hpp>

Sobel::Sobel()
{
    m_xDerivative = 1;
    m_yDerivative = 0;
}

Sobel::~Sobel()
{
}

int Sobel::getXDerivative() const
{
    return m_xDerivative;
}

void Sobel::setXDerivative(const int& xDerivative)
{
    if (xDerivative > 2)
    {
        std::cerr << "xDerivative can not be > 2\n";
        return;
    }
    if (xDerivative == 0 && m_yDerivative == 0)
    {
        m_yDerivative = 1;
    }

    m_xDerivative = xDerivative;
}

int Sobel::getYDerivative() const
{
    return m_yDerivative;
}

void Sobel::setYDerivative(const int& yDerivative)
{
    if (yDerivative > 2)
    {
        std::cerr << "yDerivative can not be > 2\n";
        return;
    }
    if (yDerivative == 0 && m_xDerivative == 0)
    {
        m_xDerivative = 1;
    }

    m_yDerivative = yDerivative;
}

void Sobel::calculate(cv::Mat& input)
{
    if (input.channels() > 1)
    {
        cv::cvtColor(input, input, CV_BGR2GRAY);
    }

    cv::Sobel(input, input, CV_8U, m_xDerivative, m_yDerivative);
}
