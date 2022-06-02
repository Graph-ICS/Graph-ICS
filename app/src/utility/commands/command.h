#ifndef COMMAND_H
#define COMMAND_H

#include <QSharedPointer>

class Command
{
public:
    typedef QSharedPointer<Command> Pointer;

    virtual ~Command()
    {
    }

    virtual void execute() = 0;
    virtual void unexecute() = 0;
    virtual bool isReversible() const = 0;
};

#endif // COMMAND_H
