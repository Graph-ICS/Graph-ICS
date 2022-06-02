#ifndef GVIDEOTASK_H
#define GVIDEOTASK_H

#include "imagetask.h"
#include "video.h"

#include "commandhistory.h"
#include "copyframescommand.h"

#include <opencv2/core.hpp>
#include <opencv2/videoio.hpp>

namespace G
{

class VideoTask : public ImageTask
{
    Q_OBJECT
    Q_PROPERTY(bool isPauseAllowed READ isPauseAllowed NOTIFY allowedChanged)

    Q_PROPERTY(bool isSaveVideoAllowed READ isSaveVideoAllowed NOTIFY allowedChanged)
    Q_PROPERTY(bool isCancelSaveVideoAllowed READ isCancelSaveVideoAllowed NOTIFY allowedChanged)
    Q_PROPERTY(bool isSavingVideo READ isSavingVideo NOTIFY savingVideoChanged)

    Q_PROPERTY(bool isCutFramesAllowed READ isCutFramesAllowed NOTIFY editPropertyChanged)
    Q_PROPERTY(bool isCopyFramesAllowed READ isCopyFramesAllowed NOTIFY editPropertyChanged)
    Q_PROPERTY(bool isPasteFramesAllowed READ isPasteFramesAllowed NOTIFY editPropertyChanged)
    Q_PROPERTY(bool isUndoAllowed READ isUndoAllowed NOTIFY editPropertyChanged)
    Q_PROPERTY(bool isRedoAllowed READ isRedoAllowed NOTIFY editPropertyChanged)
    Q_PROPERTY(int editFromFrameId READ getEditFromFrameId WRITE setEditFromFrameId NOTIFY editPropertyChanged)
    Q_PROPERTY(int editToFrameId READ getEditToFrameId WRITE setEditToFrameId NOTIFY editPropertyChanged)
    Q_PROPERTY(int pastePosition READ getPastePosition WRITE setPastePosition NOTIFY editPropertyChanged)
    Q_PROPERTY(int amountOfCopiedFrames READ getAmountOfCopiedFrames NOTIFY editPropertyChanged)

    Q_PROPERTY(int frameId READ getFrameId WRITE setFrameId NOTIFY frameIdChanged)
    Q_PROPERTY(int amountOfFrames READ getAmountOfFrames WRITE setAmountOfFrames NOTIFY amountOfFramesChanged)

public:
    enum STATE
    {
        STOP,
        PLAY,
        PAUSE
    };
    Q_ENUM(STATE)

    enum CANCEL_NOT_ALLOWED_REASON
    {
        UNSAVED_VIDEO
    };
    Q_ENUM(CANCEL_NOT_ALLOWED_REASON)

    VideoTask();

    Q_INVOKABLE virtual void init(G::Node* node) override;

    Q_INVOKABLE virtual bool isCancelAllowed() override;

    virtual bool isStopAllowed() const override;
    virtual bool isPlayAllowed() const override;
    virtual bool isPauseAllowed() const;

    virtual bool isSaveVideoAllowed() const;
    virtual bool isCancelSaveVideoAllowed() const;
    bool isSavingVideo() const;

    bool isCutFramesAllowed() const;
    bool isCopyFramesAllowed() const;
    bool isPasteFramesAllowed() const;
    bool isUndoAllowed() const;
    bool isRedoAllowed() const;

    Q_INVOKABLE virtual void stop() override;
    Q_INVOKABLE virtual void play() override;
    Q_INVOKABLE virtual void pause();

    Q_INVOKABLE QList<QString> getSupportedVideoFiles() const;
    Q_INVOKABLE virtual void saveVideoAs(QString path);
    Q_INVOKABLE virtual void cancelSaveVideo();

    Q_INVOKABLE void cutFrames();
    Q_INVOKABLE void copyFrames();
    Q_INVOKABLE void pasteFrames();
    Q_INVOKABLE void undoCommand();
    Q_INVOKABLE void redoCommand();

    Q_INVOKABLE void startSliding(const int& frameId);
    Q_INVOKABLE void endSliding(const int& frameId);

    int getEditFromFrameId() const;
    void setEditFromFrameId(const int& fromFrameId);

    int getEditToFrameId() const;
    void setEditToFrameId(const int& toFrameId);

    int getPastePosition() const;
    void setPastePosition(const int& pp);

    int getAmountOfCopiedFrames() const;

    int getFrameId() const;
    void setFrameId(const int& frameId);

    int getAmountOfFrames() const;

    void setIgnoreFps(const bool& value);

    virtual void execute() override;

signals:
    void editPropertyChanged();
    void frameIdChanged();
    void amountOfFramesChanged();
    void savingVideoChanged();

protected:
    void setAmountOfFrames(const int& amount);
    void updateFrameId(const int& frameId);
    void clearFrameMap();
    int getMappedFrameId(const int& frameId);
    void handleFps(Node* inputNode);

    virtual bool process(Node* node, Port* fromPort, Port* toPort) override;

    Node* m_inputNode;

    QVector<int> m_savePoints;

private:
    bool openVideoWriter();
    void cleanupAfterSaveVideo(SAVE_STATUS status);
    void fixFrameIdAfterEditing();
    void fixSavePointsAfterEditing();

    Video* m_videoNode;

    int m_frameId;
    int m_requestedFrameId;
    int m_processFrameId;
    int m_previousState;

    int m_editFromFrameId;
    int m_editToFrameId;
    int m_pastePosition;

    QVector<int> m_frameMap;
    CommandHistory m_commandHistory;
    CopyFramesCommand m_copyFramesCommand;

    bool m_saveVideoRequested;
    bool m_cancelSaveVideoRequested;
    bool m_saveVideoStarted;
    QString m_savePath;
    QList<QString> m_supportedVideoFiles;
    QMap<QString, QString> m_videoCodecs;
    cv::VideoWriter m_videoWriter;

    bool m_firstRun;
    bool m_ignoreFps;
};

} // namespace G

#endif // GVIDEOTASK_H
