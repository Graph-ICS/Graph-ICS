#ifndef SOBEL_H
#define SOBEL_H

#include "isobel.hpp"

class Sobel : public ISobel
{
public:
    Sobel();
    ~Sobel();

    int getXDerivative() const override;
    void setXDerivative(const int& xDerivative) override;

    int getYDerivative() const override;
    void setYDerivative(const int& yDerivative) override;

    void calculate(cv::Mat& input) override;

private:
    int m_xDerivative;
    int m_yDerivative;
};

#endif // SOBEL_H