#ifndef ITKSUBSTRACTFILTER_H
#define ITKSUBSTRACTFILTER_H

#include "node.h"

class ItkSubstractFilter : public Node
{
    Q_OBJECT

signals:
    void doShowWarningSubstractFilter();

public:
    explicit ItkSubstractFilter();
    virtual ~ItkSubstractFilter() {}

    Q_INVOKABLE bool getShowWarning() const {return getWarning;}

    virtual bool retrieveResult();

    void callShowWarningSubstractFilterInQML() {
     emit doShowWarningSubstractFilter();
    }

private:
    QPixmap m_img1;
    QPixmap m_img2;

    bool getWarning = false;

};


#endif // ITKSUBSTRACTFILTER_H
