//#include "controller.h"


//Controller::Controller() :
//    workerThread(),
//    m_worker(new Worker()) {

//    m_worker->moveToThread(&workerThread);
//    connect(&workerThread, &QThread::finished, m_worker, &QObject::deleteLater);
//    connect(this, &Controller::operate, m_worker, &Worker::doWork);
//    connect(m_worker, &Worker::resultReady, this, &Controller::handleResults);

//    workerThread.start();

//}

//Controller::~Controller() {
//    workerThread.quit();
//    workerThread.wait();
//}

//Worker Controller::getWorker()
//{
//    return m_worker;
//}


//void Controller::handleResults(Node *node)
//{

//}

