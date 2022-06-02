#ifndef IMAGE_H
#define IMAGE_H

#include "node.h"

namespace G
{
class Image : public Node
{
    Q_OBJECT

public:
    Image();
    bool retrieveResult() override;

    Q_INVOKABLE QList<QString> getAcceptedFiles() const;

private:
    Port m_outPort;

    QList<QString> m_acceptedFiles;
    Attribute* m_path;
};
} // namespace G
#endif // IMAGE_H
