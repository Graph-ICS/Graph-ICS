#include "itksubtract.h"

#include "imageconverter.h"
#include <QDebug>
#include <itkSubtractImageFilter.h>

namespace G
{

ItkSubtract::ItkSubtract()
    : Node("ItkSubtract")
    , m_imageOneInPort(Port::TYPE::GIMAGE)
    , m_imageTwoInPort(Port::TYPE::GIMAGE)
    , m_outPort(Port::TYPE::GIMAGE)
{
    registerPorts({&m_imageOneInPort, &m_imageTwoInPort}, {&m_outPort});

    registerCreationMessage(
        "If the connected Images have the same size, the first connected Image always gets subtracted "
        "to the second Image!");
}

bool ItkSubtract::retrieveResult()
{
    try
    {
        GImage::Pointer img1 = m_imageOneInPort.getGImage();
        GImage::Pointer img2 = m_imageTwoInPort.getGImage();

        if (img1->getQPixmap().size().height() > img2->getQPixmap().size().height() ||
            img1->getQPixmap().size().width() > img2->getQPixmap().size().width())
        {
            // swap
            GImage::Pointer temp = img1;
            img1 = img2;
            img2 = temp;
        }

        itk::Image<unsigned char, 2>::Pointer& itkImage1 = img1->getItkImage();
        itk::Image<unsigned char, 2>::Pointer& itkImage2 = img2->getItkImage();

        typedef itk::SubtractImageFilter<itk::Image<unsigned char, 2>> SubtractType;
        SubtractType::Pointer diff = SubtractType::New();
        diff->SetInput1(itkImage1);
        diff->SetInput2(itkImage2);
        diff->Update();

        itkImage1 = diff->GetOutput();

        m_outPort.getGImage()->setImage(itkImage1);
    }
    catch (int e)
    {
        qDebug() << "ItkSubstract. Exception Nr. " << e << '\n';
        return false;
    }

    return true;
}
} // namespace G
