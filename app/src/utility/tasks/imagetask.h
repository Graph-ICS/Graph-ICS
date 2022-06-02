#ifndef GIMAGETASK_H
#define GIMAGETASK_H

#include "node.h"
#include "task.h"

namespace G
{
class ImageTask : public Task
{
    Q_OBJECT
    Q_PROPERTY(bool isPlayAllowed READ isPlayAllowed NOTIFY allowedChanged)
    Q_PROPERTY(bool isStopAllowed READ isStopAllowed NOTIFY allowedChanged)
    Q_PROPERTY(int state READ getState NOTIFY stateChanged)

public:
    enum STATE
    {
        STOP,
        PLAY
    };
    Q_ENUM(STATE)

    enum SAVE_STATUS
    {
        SUCCESSED,
        FILE_NOT_SUPPORTED,
        EMPTY_RESULT,
        WRITER_ERROR,
        CANCELLED
    };
    Q_ENUM(SAVE_STATUS)

    ImageTask();

    /*!
     * \brief Works as a parameterized constructor, QML exposed classes need a default constructor.
     * \param node
     */
    Q_INVOKABLE virtual void init(G::Node* node);

    virtual bool isStopAllowed() const;
    virtual bool isPlayAllowed() const;

    Q_INVOKABLE virtual void stop();
    Q_INVOKABLE virtual void play();

    Q_INVOKABLE QList<QString> getSupportedImageFiles() const;
    Q_INVOKABLE void saveImageAs(QString filepath);

    int getState() const;
    void changeState(int state);
    bool isStateChangeRequested() const;

    void execute() override;
    void update() override;

signals:
    void stateChanged();
    void saveResultAsFinished(int status);

protected:
    bool startProcess(Node* node);
    bool processInNodes(Node* node);
    virtual bool process(Node* node, Port* fromPort, Port* toPort);

    void forwardResult(Port* outPort, Port* inPort);

    virtual void onResumed() override;
    virtual void onSuspended() override;
    virtual void onCancelled() override;

    bool setSupportedFiletype(QString filepath, QList<QString> supportedFiletypes);

    Node* m_node;

    QString m_filetype;
    QList<QString> m_supportedImageFiles;

private:
    bool m_nodeLocked;
    int m_state;
    int m_requestedState;
};
} // namespace G

#endif // GIMAGETASK_H
