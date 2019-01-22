#ifndef CVMEDIANFILTER_H
#define CVMEDIANFILTER_H

#include "node.h"

class CvMedianFilter : public Node
{
    Q_OBJECT
    Q_PROPERTY(int kernelSize READ getFilterParameter WRITE setFilterParameter NOTIFY kernelSizeChanged)

public:
    explicit CvMedianFilter();

    bool retrieveResult();

    int getFilterParameter() const;
    void setFilterParameter(int value);

signals:
    void kernelSizeChanged();

private:
    //ksize - aperture linear size;
    //it must be odd and greater than 1, for example: 3, 5, 7 ...
    int kernelSize;
};

#endif // CVMEDIANFILTER_H
