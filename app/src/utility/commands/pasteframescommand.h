#ifndef PASTEFRAMESCOMMAND_H
#define PASTEFRAMESCOMMAND_H

#include "command.h"
#include "copyframescommand.h"

#include <QVector>

class PasteFramesCommand : public Command
{
public:
    PasteFramesCommand(QVector<int>& frameMap, const CopyFramesCommand& copyCommand, const int& index);

    void execute() override;
    void unexecute() override;
    bool isReversible() const override;

private:
    QVector<int>& m_frameMap;
    const CopyFramesCommand m_copyCommand;
    int m_index;
};

#endif // PASTEFRAMESCOMMAND_H
