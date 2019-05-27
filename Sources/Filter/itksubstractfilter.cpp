#include "itksubstractfilter.h"

#include <itkSubtractImageFilter.h>
#include "imageconverter.h"
#include <QDebug>

ItkSubstractFilter::ItkSubstractFilter()
{

}

bool ItkSubstractFilter::retrieveResult()
{
    qDebug() << m_inNodes.size();
    if (m_inNodes.size() < 2) {
        return false;
    }
    else {
        try {

            //hier muss bestimmt werden was input1 und was input2 ist
            getWarning = false;

            m_img = m_inNodes[0]->getResult();
            //1. get the current image object
            m_img1 = m_inNodes[0]->getResult();
            m_img2 = m_inNodes[1]->getResult();

            qDebug() << m_img1;
            qDebug() << m_img2;

            if(m_img1.size().height() < m_img2.size().height()) {
                qDebug() << "image1 größer als image2";
            }
            else if (m_img1.size().height() > m_img2.size().height()){
                qDebug() <<"image2 größer als image1";
                m_img = QPixmap();
                getWarning = true;
                return false;
            }
            QImage img1 = m_img1.toImage();
            QImage img2 = m_img2.toImage();


            //3. Convert QImage to ITK Image
            itk::Image< unsigned char, 2>::Pointer itkImageIn1 = itk::Image< unsigned char, 2>::New();
            itk::Image< unsigned char, 2>::Pointer itkImageIn2 = itk::Image< unsigned char, 2>::New();
            ImageConverter::itkImageFromQImage(itkImageIn1, img1);
            ImageConverter::itkImageFromQImage(itkImageIn2, img2);

            //4. apply the filter
            typedef itk::SubtractImageFilter< itk::Image< unsigned char, 2> > SubtractType;
            SubtractType::Pointer diff = SubtractType::New();
            diff->SetInput1(itkImageIn1);
            diff->SetInput2(itkImageIn2);
            diff->Update();

            itkImageIn1 = diff->GetOutput();

            //5. convert to QImage
            ImageConverter::qImageFromITKImage(itkImageIn1, img1);
            //6. continue the flow
            m_img = QPixmap::fromImage(img1);

        } catch (int e) {
            qDebug() << "ItkSubstractFilter. Exception Nr. " << e << '\n';
            return false;
        }
    }
    return true;
}


