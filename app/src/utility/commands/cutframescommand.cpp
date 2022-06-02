#include "cutframescommand.h"
#include <QDebug>

CutFramesCommand::CutFramesCommand(QVector<int>& frameMap, const int& from, const int& to)
    : m_frameMap(frameMap)
    , m_from(from)
    , m_to(to)
    , m_copyCommand(frameMap)
{
    m_copyCommand.setFromTo(m_from, m_to);
}

void CutFramesCommand::execute()
{
    Q_ASSERT(m_to < m_frameMap.size());

    m_count = (m_to - m_from) + 1;

    Q_ASSERT((m_from + m_count) - 1 < m_frameMap.size());

    m_copyCommand.execute();
    m_frameMap.remove(m_from, m_count);
}

void CutFramesCommand::unexecute()
{
    PasteFramesCommand paste(m_frameMap, m_copyCommand, m_from);
    paste.execute();
}

bool CutFramesCommand::isReversible() const
{
    return m_count > 0;
}
