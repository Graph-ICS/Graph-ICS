#include "commandhistory.h"

CommandHistory::CommandHistory()
    : m_history()
{
    m_presentOffset = 0;
}

void CommandHistory::add(Command::Pointer command)
{
    if (command->isReversible())
    {
        for (; m_presentOffset > 0; m_presentOffset--)
        {
            m_history.pop_front();
        }

        m_history.push_front(command);

        if (m_history.size() > HISTORY_LENGTH)
        {
            m_history.pop_back();
        }
    }
}

void CommandHistory::clear()
{
    m_history.clear();
}

void CommandHistory::undo()
{
    if (canUndo())
    {
        m_history.at(m_presentOffset)->unexecute();
        m_presentOffset++;
    }
}

void CommandHistory::redo()
{
    if (canRedo())
    {
        m_presentOffset--;
        m_history.at(m_presentOffset)->execute();
    }
}

bool CommandHistory::canUndo() const
{
    return m_presentOffset < m_history.size();
}

bool CommandHistory::canRedo() const
{
    return m_presentOffset > 0;
}

int CommandHistory::getUndoDepth() const
{
    return m_history.size() - m_presentOffset;
}
