#include "remotesobel.h"

#include "sobelstub.h"

namespace G
{

RemoteSobel::RemoteSobel()
    : RemoteExampleNode()
    , m_xDerivative(attributeFactory.makeIntTextField(1, 0, 2, 1, "x-Derivative"))
    , m_yDerivative(attributeFactory.makeIntTextField(0, 0, 2, 1, "y-Derivative"))
    , m_inPort(Port::TYPE::GIMAGE)
    , m_outPort(Port::TYPE::GIMAGE)
    , m_service(new SobelStub(this))
{
    registerPorts({&m_inPort}, {&m_outPort});
    registerAttribute("xDerivative", m_xDerivative);
    registerAttribute("yDerivative", m_yDerivative);
}

RemoteSobel::~RemoteSobel()
{
    delete m_service;
}

bool RemoteSobel::retrieveResult()
{
    cv::Mat& mat = m_inPort.getGImage()->getCvMatImage();
    m_service->calculate(mat);

    m_outPort.getGImage()->setImage(mat);
    return true;
}

void RemoteSobel::onAttributeValueChanged(Attribute* attribute)
{
    clearStreamCache();
    // set the attribute value via a synchroneous rpc call on the server
    if (attribute == m_xDerivative)
    {
        m_service->setXDerivative(attribute->getValue().toInt());
    }
    else
    {
        m_service->setYDerivative(attribute->getValue().toInt());
    }

    // get the value validated by the server
    int validatedValue = m_service->getXDerivative();
    m_xDerivative->setValue(validatedValue);

    validatedValue = m_service->getYDerivative();
    m_yDerivative->setValue(validatedValue);
}
} // namespace G
