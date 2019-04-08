#ifndef ITKWATERSHEDFILTER_H
#define ITKWATERSHEDFILTER_H

#include "node.h"

class ItkWatershedFilter : public Node
{
    Q_OBJECT
    Q_PROPERTY(double level READ getLevel WRITE setLevel NOTIFY levelChanged)
    Q_PROPERTY(double threshold READ getThreshold WRITE setThreshold NOTIFY thresholdChanged)

public:
    explicit ItkWatershedFilter();
    virtual ~ItkWatershedFilter() {}

    double getLevel() const;
    void setLevel(double value);

    double getThreshold() const;
    void setThreshold(double value);

    virtual bool retrieveResult();
signals:
    void levelChanged();
    void thresholdChanged();

private:
    double level;
    double threshold;

};

#endif // ITKWATERSHEDFILTER_H
