#ifndef CAMERA_H
#define CAMERA_H

#include "node.h"
#include <QDebug>
#include <QObject>

#include <QVector>
#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>

namespace G
{
class Camera : public Node
{
    Q_OBJECT
public:
    Camera();
    ~Camera();

    bool retrieveResult() override;
    void onAttributeValueChanged(Attribute* attribute) override;

    bool isCameraDeviceOpen() const;
    bool openCamera();
    void closeCamera(bool force = false);

private:
    static QVector<int> openCameraDevices;

    Port m_outPort;
    Attribute* m_fps;
    Attribute* m_device;

    cv::VideoCapture m_capture;

    int m_cameraOpenCounter;
};
} // namespace G

#endif // CAMERA_H
