#ifndef ITKSUBSTRACTFILTER_H
#define ITKSUBSTRACTFILTER_H

#include "node.h"

class ItkSubstractFilter : public Node
{
    Q_OBJECT
public:
    explicit ItkSubstractFilter();

    bool retrieveResult();

private:
    QPixmap m_img1;
    QPixmap m_img2;


};


#endif // ITKSUBSTRACTFILTER_H
