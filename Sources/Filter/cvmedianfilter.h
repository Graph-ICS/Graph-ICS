#ifndef CVMEDIANFILTER_H
#define CVMEDIANFILTER_H

#include "node.h"

class CvMedianFilter : public Node
{
    Q_OBJECT
    Q_PROPERTY(int kernelSize READ getKernelSize WRITE setKernelSize NOTIFY kernelSizeChanged)

public:
    explicit CvMedianFilter();
    ~CvMedianFilter() {}

    virtual bool retrieveResult();

    int getKernelSize() const;
    void setKernelSize(int value);

signals:
    void kernelSizeChanged();

private:
    //ksize - aperture linear size;
    //it must be odd and greater than 1, for example: 3, 5, 7 ...
    int m_kernelSize;
};

#endif // CVMEDIANFILTER_H
