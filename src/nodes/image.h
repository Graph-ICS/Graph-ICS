#ifndef IMAGE_H
#define IMAGE_H

#include "node.h"

class Image : public Node
{
    Q_OBJECT

public:
    explicit Image();

    bool retrieveResult();
};

#endif // IMAGE_H
