#ifndef CVSOBELOPERATOR_H
#define CVSOBELOPERATOR_H

#include "node.h"

namespace G
{
class CvSobelOperator : public Node
{
    Q_OBJECT

public:
    explicit CvSobelOperator();
    virtual ~CvSobelOperator()
    {
    }

    bool retrieveResult() override;
    void onAttributeValueChanged(Attribute* attribute) override;

private:
    Port m_inPort;
    Port m_outPort;

    Attribute* m_xDerivative;
    Attribute* m_yDerivative;
};
} // namespace G

#endif // CVSOBELOPERATOR_H
