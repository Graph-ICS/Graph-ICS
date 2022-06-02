#include "copyframescommand.h"

CopyFramesCommand::CopyFramesCommand(const QVector<int>& frameMap)
    : m_frameMap(frameMap)
    , m_copiedFrames()
{
    m_hasCopy = false;
}

void CopyFramesCommand::execute()
{
    int count = (m_to - m_from) + 1;
    m_copiedFrames = m_frameMap.mid(m_from, count);

    m_hasCopy = true;
}

void CopyFramesCommand::unexecute()
{
    m_copiedFrames.clear();
    m_hasCopy = false;
}

bool CopyFramesCommand::isReversible() const
{
    return false;
}

void CopyFramesCommand::setFromTo(const int& from, const int& to)
{
    m_from = from;
    m_to = to;
}

bool CopyFramesCommand::hasCopy() const
{
    return m_hasCopy;
}

const QVector<int>& CopyFramesCommand::getCopiedFrames() const
{
    return m_copiedFrames;
}
