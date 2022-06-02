#ifndef CUTFRAMESCOMMAND_H
#define CUTFRAMESCOMMAND_H

#include "command.h"
#include "copyframescommand.h"
#include "pasteframescommand.h"

#include <QVector>

class CutFramesCommand : public Command
{
public:
    CutFramesCommand(QVector<int>& frameMap, const int& from, const int& to);

    void execute() override;
    void unexecute() override;
    bool isReversible() const override;

private:
    QVector<int>& m_frameMap;
    int m_from;
    int m_to;

    CopyFramesCommand m_copyCommand;
    int m_count;
};

#endif // CUTFRAMESCOMMAND_H
