#ifndef COMMANDHISTORY_H
#define COMMANDHISTORY_H

#include "command.h"

#include <QQueue>

class CommandHistory
{
public:
    CommandHistory();

    void add(Command::Pointer command);
    void clear();

    void undo();
    void redo();

    bool canUndo() const;
    bool canRedo() const;

    int getUndoDepth() const;

private:
    QVector<Command::Pointer> m_history;
    int m_presentOffset;

    enum
    {
        HISTORY_LENGTH = 20
    };
};

#endif // COMMANDHISTORY_H
