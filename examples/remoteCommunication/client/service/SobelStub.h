#ifndef SOBELSTUB_H
#define SOBELSTUB_H

#include "isobel.hpp"
#include "remoteexamplenode.h"

class SobelStub : public ISobel
{
public:
    SobelStub(RemoteExampleNode* node);
    ~SobelStub();

    int getXDerivative() const override;
    void setXDerivative(const int& xDerivative) override;

    int getYDerivative() const override;
    void setYDerivative(const int& yDerivative) override;

    void calculate(cv::Mat& input) override;

private:
    const RemoteExampleNode* m_node;

    const boost::uuids::uuid m_id;
};

#endif // SOBELSTUB_H
