#if !defined(VIEW_H)
#define VIEW_H

#include <QObject>
#include <QVariant>

#include "node.h"

namespace G
{
class View : public Node
{
    Q_OBJECT
public:
    View(const QString& name);
    virtual ~View();

    bool retrieveResult() = 0;
    Q_INVOKABLE virtual void clear() = 0;

signals:
    void updated();
    void cleared();
};
} // namespace G

#endif // VIEW_H
