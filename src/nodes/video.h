#ifndef VIDEO_H
#define VIDEO_H

#include <node.h>
#include <QObject>
#include <QDebug>
#include <QDateTime>

#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui.hpp>


class Video : public Node
{
    Q_OBJECT

public:
    Video();
    ~Video();

    bool retrieveResult() override;
    bool inputType(Node*) override;
    bool startVideo();

    void setAttributeValue(QString attributeName, QVariant value) override;

private:
    cv::VideoCapture m_capture;
    QString m_path;
    int m_amountOfFrames;
    int m_currentFrame;
    int m_fps;

    qint64 m_offset;
    qint64 m_interval;
};

#endif // VIDEO_H
