#include "pasteframescommand.h"

PasteFramesCommand::PasteFramesCommand(QVector<int>& frameMap, const CopyFramesCommand& copyCommand, const int& index)
    : m_frameMap(frameMap)
    , m_copyCommand(copyCommand)
    , m_index(index)
{
}

void PasteFramesCommand::execute()
{
    for (int i = m_copyCommand.getCopiedFrames().size() - 1; i >= 0; i--)
    {
        m_frameMap.insert(m_index, m_copyCommand.getCopiedFrames().at(i));
    }
}

void PasteFramesCommand::unexecute()
{
    m_frameMap.remove(m_index, m_copyCommand.getCopiedFrames().size());
}

bool PasteFramesCommand::isReversible() const
{
    return m_copyCommand.getCopiedFrames().size() > 0;
}
