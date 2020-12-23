#ifndef CAMERA_H
#define CAMERA_H

#include "node.h"
#include <QObject>
#include <QDebug>

#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui.hpp>

class Camera : public Node
{
    Q_OBJECT
public:
    Camera();
    ~Camera();

    bool retrieveResult();


private:
    cv::VideoCapture m_capture;
};

#endif // CAMERA_H
