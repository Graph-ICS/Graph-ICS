#ifndef CAMERA_H
#define CAMERA_H

#include "node.h"
#include <QObject>
#include <QDebug>

#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui.hpp>
#include <QVector>

class Camera : public Node
{
    Q_OBJECT
public:
    Camera();
    ~Camera();

    bool retrieveResult();
    bool inputType(Node* startNode);

//    void setAttributeValue(QString name, QVariant value);

private:
    cv::VideoCapture m_capture;

    int m_instanceNumber;
    static int m_instances;
};

#endif // CAMERA_H
