//#ifndef CONTROLLER_H
//#define CONTROLLER_H
//#include <QObject>
//#include <QThread>
//#include "node.h"
//#include "worker.h"


// //Diese Klasse kümmert sich zusammen mit der Klasse Worker um das Multithreading: NICHT FERTIG! Code muss noch geändert werden

//class Controller : public QObject
//{
//    Q_OBJECT
//    Q_PROPERTY(Worker worker READ getWorker)

//public:
//    Controller();
//    ~Controller();

//    Worker getWorker() const;


//public slots:
//    void handleResults(Node* node); // für das connect im cpp
//signals:
//    void operate(Node* node); // für das connect im cpp

//private:
//    QThread workerThread;
//    Worker* m_worker;
//};

//#endif // CONTROLLER_H
