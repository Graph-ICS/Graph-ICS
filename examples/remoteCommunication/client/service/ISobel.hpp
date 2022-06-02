#ifndef ISOBEL_HPP
#define ISOBEL_HPP

#include <opencv2/core/mat.hpp>

class ISobel
{
public:
    virtual ~ISobel(){};

    virtual int getXDerivative() const = 0;
    virtual void setXDerivative(const int& xDerivative) = 0;

    virtual int getYDerivative() const = 0;
    virtual void setYDerivative(const int& yDerivative) = 0;

    virtual void calculate(cv::Mat& input) = 0;
};

#endif // ISOBEL_HPP
