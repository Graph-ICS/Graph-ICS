#ifndef GCAMERATASK_H
#define GCAMERATASK_H

#include "videotask.h"

#include "camera.h"

namespace G
{
class CameraTask : public VideoTask
{
    Q_OBJECT
    Q_PROPERTY(bool isRecordAllowed READ isRecordAllowed NOTIFY allowedChanged)
    Q_PROPERTY(bool isOpenCameraAllowed READ isOpenCameraAllowed NOTIFY allowedChanged)
    Q_PROPERTY(bool isCloseCameraAllowed READ isCloseCameraAllowed NOTIFY allowedChanged)
    Q_PROPERTY(bool isCamOn READ isCamOn NOTIFY camOnChanged)
public:
    enum STATE : int
    {
        STOP,
        PLAY,
        PAUSE,
        RECORD,
        RECORD_PAUSE
    };
    Q_ENUM(STATE)

    enum CANCEL_NOT_ALLOWED_REASON
    {
        UNSAVED_VIDEO,
        IS_RECORDING_VIDEO
    };
    Q_ENUM(CANCEL_NOT_ALLOWED_REASON)

    CameraTask();
    ~CameraTask();

    void init(G::Node* node) override;

    virtual bool isCancelAllowed() override;

    virtual bool isStopAllowed() const override;
    virtual bool isPlayAllowed() const override;
    virtual bool isPauseAllowed() const override;
    virtual bool isRecordAllowed() const;

    virtual bool isOpenCameraAllowed() const;
    virtual bool isCloseCameraAllowed() const;
    bool isCamOn() const;
    Q_INVOKABLE bool isCameraDeviceOpen() const;

    virtual bool isSaveVideoAllowed() const override;

    Q_INVOKABLE virtual void stop() override;
    Q_INVOKABLE virtual void play() override;
    Q_INVOKABLE virtual void pause() override;
    Q_INVOKABLE virtual void record();

    Q_INVOKABLE void openCamera();
    Q_INVOKABLE void closeCamera();

    Q_INVOKABLE void clearRecordedFrames();

    void execute() override;

signals:
    void camOnChanged();

protected:
    virtual bool process(Node* node, Port* fromPort, Port* toPort) override;

    virtual void onCancelled() override;

private:
    void setCamOn(const bool& value);

    Camera* m_cameraNode;

    bool m_openCameraRequested;
    bool m_closeCameraRequested;

    bool m_finalizeRecording;
    bool m_hasRecordedFrames;

    bool m_camOn;
};
} // namespace G

#endif // GCAMERATASK_H
