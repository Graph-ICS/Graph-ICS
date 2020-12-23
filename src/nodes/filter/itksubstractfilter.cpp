#include "itksubstractfilter.h"

#include <itkSubtractImageFilter.h>
#include "imageconverter.h"
#include <QDebug>

ItkSubstractFilter::ItkSubstractFilter()
{
    m_inPortCount = 2;
    m_nodeName = "ItkSubtract";
    m_warningMessage = "If the connected Images have the same size, the first connected Image always gets subtracted to the second Image!";
}

bool ItkSubstractFilter::retrieveResult()
{
    if (m_inNodes.size() < 2) {
        return false;
    }
    else {
        try {

            GImage img1 = m_inNodes[0]->getResult();
            GImage img2 = m_inNodes[1]->getResult();

            if(!img1.isSet() || !img2.isSet()){
                return false;
            }

            if (img1.getQPixmap().size().height() > img2.getQPixmap().size().height() || img1.getQPixmap().size().width() > img2.getQPixmap().size().width()){
                // swap
                GImage temp = img1;
                img1 = img2;
                img2 = temp;
            }

            itk::Image<unsigned char, 2>::Pointer itkImage1 = img1.getItkImage();
            itk::Image<unsigned char, 2>::Pointer itkImage2 = img2.getItkImage();


            typedef itk::SubtractImageFilter< itk::Image< unsigned char, 2> > SubtractType;
            SubtractType::Pointer diff = SubtractType::New();
            diff->SetInput1(itkImage1);
            diff->SetInput2(itkImage2);
            diff->Update();

            itkImage1 = diff->GetOutput();


            m_img.setImage(itkImage1);

        } catch (int e) {
            qDebug() << "ItkSubstractFilter. Exception Nr. " << e << '\n';
            return false;
        }
    }
    return true;
}


