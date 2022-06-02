#ifndef VIDEO_H
#define VIDEO_H

#include <QDateTime>
#include <QDebug>
#include <QObject>
#include <node.h>

#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>

namespace G
{
class Video : public Node
{
    Q_OBJECT

public:
    Video();
    ~Video();

    bool retrieveResult() override;
    void onAttributeValueChanged(Attribute* attribute) override;

    Q_INVOKABLE QList<QString> getAcceptedFiles() const;

    bool isVideoOpen() const;
    bool openVideo();

    int getAmountOfFrames() const;
    int getFrameId() const;
    void setFrameId(const int& frameId);

private:
    Port m_outPort;

    QList<QString> m_acceptedFiles;
    Attribute* m_path;
    Attribute* m_fps;

    cv::VideoCapture m_capture;

    int m_amountOfFrames;
    int m_frameId;

    // frames per millisecond
    double m_fpms;
};
} // namespace G

#endif // VIDEO_H
