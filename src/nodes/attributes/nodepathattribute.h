#ifndef NODEPATHATTRIBUTE_H
#define NODEPATHATTRIBUTE_H

#include "nodeattribute.h"

#ifdef __linux__
    #define PATHOVERHEAD 7
#else //__WIN32__
    #define PATHOVERHEAD 8
#endif

class NodePathAttribute : public NodeAttribute
{
public:
    // nameFilter muss in " " stehen: \" -> fuer Anführungszeichen im String (z.B "\"All files (*)\"")
    // es koennen auch mehrere nameFilter angegeben werden diese muessen mit komma getrennt werden
    NodePathAttribute(QString nameFilter, QString path = "");

    void setValue(QVariant value);

};

#endif // NODEPATHATTRIBUTE_H
