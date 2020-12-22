#ifndef CVSOBELOPERATORFILTER_H
#define CVSOBELOPERATORFILTER_H

#include "node.h"

class CvSobelOperatorFilter : public Node
{
    Q_OBJECT

public:
    explicit CvSobelOperatorFilter();
    virtual ~CvSobelOperatorFilter() {}

    virtual bool retrieveResult() override;

    void setAttributeValue(QString attributeName, QVariant value) override;

};

#endif // CVSOBELOPERATORFILTER_H
