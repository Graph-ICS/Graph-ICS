#ifndef COPYCOMMAND_H
#define COPYCOMMAND_H

#include "command.h"

class CopyFramesCommand : public Command
{
public:
    CopyFramesCommand(const QVector<int>& frameMap);

    void execute() override;
    void unexecute() override;
    bool isReversible() const override;

    void setFromTo(const int& from, const int& to);
    bool hasCopy() const;

    const QVector<int>& getCopiedFrames() const;

private:
    const QVector<int>& m_frameMap;
    int m_from;
    int m_to;

    QVector<int> m_copiedFrames;
    bool m_hasCopy;
};

#endif // COPYCOMMAND_H
