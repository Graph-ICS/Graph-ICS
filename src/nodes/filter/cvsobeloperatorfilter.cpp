#include "cvsobeloperatorfilter.h"

#include <cv.h>
#include <opencv2/imgproc/imgproc.hpp>

#include "imageconverter.h"
#include <QDebug>

CvSobelOperatorFilter::CvSobelOperatorFilter()
{  
    registerAttribute("xDerivative", new NodeIntAttribute(1, 2));
    registerAttribute("yDerivative", new NodeIntAttribute(0, 2));
    m_nodeName = "CvSobelOperator";
}


void CvSobelOperatorFilter::setAttributeValue(QString attributeName, QVariant value )
{
    if(m_attributes.contains(attributeName)){
        NodeAttribute* attr = m_attributes.value(attributeName);

        if(attr->getValue().toInt() != value.toInt()){
            if(value.toInt() == 0){
                auto list = getAttributeNames();
                QString name;
                for(int i = 0; i < list.length(); i++){
                    if(list.at(i) != attributeName){
                        name = list.at(i);
                        break;
                    }
                }
                if(getAttributeValue(name) == 0){
                    NodeAttribute* help = m_attributes.value(name);
                    help->setValue(QVariant (1));
                    emit attributeValuesUpdated();
                }
            }
            attr->setValue(value);
            cleanCache();
        }
    } else {
        std::cerr << "an attribute with this name does not exist!";
    }
}

bool CvSobelOperatorFilter::retrieveResult()
{
    if (m_inNodes.size() < 1) {
        return false;
    }
    else {
        try {
            m_img = m_inNodes[0]->getResult();
            if(!m_img.isSet()){
                return false;
            }

            cv::Mat cvImage = m_img.getCvMatImage();

            if(cvImage.type() == CV_8UC1) {
                cv::cvtColor(cvImage, cvImage, CV_GRAY2RGB);
            }

            cvtColor(cvImage, cvImage, CV_RGB2GRAY);

            cv::Sobel(cvImage, cvImage, CV_8U, getAttributeValue("xDerivative").toInt(), getAttributeValue("yDerivative").toInt());

            m_img.setImage(cvImage);

        } catch (int e) {
            qDebug() << "CvSobelOperatorFilter. Exception Nr. " << e << '\n';
            return false;
        }
    }
    return true;
}
