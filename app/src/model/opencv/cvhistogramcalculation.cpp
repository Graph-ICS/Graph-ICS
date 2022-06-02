#include "opencv2/highgui.hpp"
#include "opencv2/imgcodecs.hpp"
#include "opencv2/imgproc.hpp"

#include "cvhistogramcalculation.h"

namespace G
{

CvHistogramCalculation::CvHistogramCalculation()
    : Node("CvHistogramCalculation")
    , m_inPort(Port::TYPE::GIMAGE)
    , m_dataOutPort(Port::TYPE::GDATA)
    , m_imageOutPort(Port::TYPE::GIMAGE)
{
    registerPorts({&m_inPort}, {&m_dataOutPort, &m_imageOutPort});
}

bool CvHistogramCalculation::retrieveResult()
{
    try
    {
        cv::Mat& cvImage = m_inPort.getGImage()->getCvMatImage();

        int histSize = 256;
        float range[] = {0, 256};
        const float* histRange = {range};

        bool uniform = true, accumulate = false;

        QList<PointSet> pointSets;

        if (cvImage.channels() > 1)
        {
            std::vector<cv::Mat> bgr_planes;
            cv::split(cvImage, bgr_planes);

            cv::Mat b_hist, g_hist, r_hist;
            cv::calcHist(&bgr_planes[0], 1, 0, cv::Mat(), b_hist, 1, &histSize, &histRange, uniform, accumulate);
            cv::calcHist(&bgr_planes[1], 1, 0, cv::Mat(), g_hist, 1, &histSize, &histRange, uniform, accumulate);
            cv::calcHist(&bgr_planes[2], 1, 0, cv::Mat(), r_hist, 1, &histSize, &histRange, uniform, accumulate);

            pointSets.append(createPointSet("blue", QColor(0, 0, 255), b_hist));
            pointSets.append(createPointSet("green", QColor(0, 255, 0), g_hist));
            pointSets.append(createPointSet("red", QColor(255, 0, 0), r_hist));

            if (pointSets[0].data == pointSets[1].data && pointSets[1].data == pointSets[2].data)
            {
                pointSets.clear();
                pointSets.append(createPointSet("gray", QColor(65, 130, 175), b_hist));
            }
        }
        else
        {
            cv::Mat hist_result;
            cv::calcHist(&cvImage, 1, 0, cv::Mat(), hist_result, 1, &histSize, &histRange, uniform, accumulate);

            pointSets.append(createPointSet("gray", QColor(65, 130, 175), hist_result));
        }

        m_dataOutPort.getGData()->setData(pointSets);
        m_imageOutPort.getGImage()->setImage(cvImage);
    }
    catch (int e)
    {
        qDebug() << "CvHistogramCalculation Exception Nr. " << e << '\n';
        return false;
    }

    return true;
}

PointSet CvHistogramCalculation::createPointSet(const QString& label, const QColor& color, const cv::Mat& mat)
{
    PointSet pSet;
    pSet.label = label;
    pSet.color = color;
    for (int i = 0; i < 256; i++)
    {
        float y;
        y = mat.at<float>(i);

        pSet.data.append(QPointF(i, y));
    }
    return pSet;
}
} // namespace G
