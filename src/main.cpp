#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QDebug>
//
#include <QQmlProperty>
//
#include "gimageprovider.h"
#include "gscheduler.h"
#include "nodeprovider.h"
#include "fileio.h"
#include "view.h"

#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui.hpp>

// Input Nodes
#include "video.h"
#include "camera.h"
#include "nodes/image.h"
// Filter
#include "qtblackwhitefilter.h"
#include "qtdarkerfilter.h"
#include "qtlighterfilter.h"
#include "itkdiscretegaussianfilter.h"
#include "itkcannyedgedetectionfilter.h"
#include "itkbinarymorphclosingfilter.h"
#include "itkbinarymorphopeningfilter.h"
#include "itksubstractfilter.h"
#include "cvmedianfilter.h"
#include "cvsobeloperatorfilter.h"
#include "cvhistogramequalization.h"
#include "itkmedianfilter.h"
#include "cverosion.h"
#include "cvdilation.h"
#include "cvfouriertransformpsd.h"
#include "cvtransformation.h"
#include "cvhistogramcalculation.h"


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_UseStyleSheetPropagationInWidgetStyles);
    QCoreApplication::setAttribute(Qt::AA_Use96Dpi);

    QApplication app(argc, argv);

    GImageProvider* gImageProvider = new GImageProvider();
    GScheduler scheduler;
    NodeProvider* nodeProvider = new NodeProvider();
    FileIO* fileIO = new FileIO();

    app.setOrganizationName("Graph-ICS");
    app.setOrganizationDomain("https://github.com/Graph-ICS/Graph-ICS");

    // input nodes
    nodeProvider->registerNode<Video>("Video");
    nodeProvider->registerNode<Camera>("Camera");
    nodeProvider->registerNode<Image>("Image");

    // filter nodes
    nodeProvider->registerNode<QtBlackWhiteFilter>("QtBlackWhite");
    nodeProvider->registerNode<QtDarkerFilter>("QtDarker");
    nodeProvider->registerNode<QtLighterFilter>("QtLighter");
    nodeProvider->registerNode<ItkMedianFilter>("ItkMedian");
    nodeProvider->registerNode<ItkDiscreteGaussianFilter>("ItkDiscreteGaussian");
    nodeProvider->registerNode<ItkCannyEdgeDetectionFilter>("ItkCannyEdgeDetection");
    nodeProvider->registerNode<ItkBinaryMorphClosingFilter>("ItkBinaryMorphClosing");
    nodeProvider->registerNode<ItkBinaryMorphOpeningFilter>("ItkBinaryMorphOpening");
    nodeProvider->registerNode<CvMedianFilter>("CvMedian");
    nodeProvider->registerNode<CvSobelOperatorFilter>("CvSobelOperator");
    nodeProvider->registerNode<ItkSubstractFilter>("ItkSubtract");
    nodeProvider->registerNode<CvHistogramEqualization>("CvHistogramEqualization");
    nodeProvider->registerNode<CvErosion>("CvErosion");
    nodeProvider->registerNode<CvDilation>("CvDilation");
    nodeProvider->registerNode<CvFourierTransformPSD>("CvFourierTransformPSD");
    nodeProvider->registerNode<CvTransformation>("CvTransformation");
    nodeProvider->registerNode<CvHistogramCalculation>("CvHistogramCalculation");

    // create Singleton object Theme
    qmlRegisterSingletonType(QUrl("qrc:/theme/Theme.qml"), "Theme", 1, 0, "Theme");

//    qRegisterMetaType<cv::Mat>("cv::Mat");
//    qRegisterMetaType<GPointSet>("GPointSet");
//    qRegisterMetaType<QVector<QPointF>>("QVector<QPointF>>");
    qmlRegisterType<View>("Model.View", 1, 0, "View_Model");

    app.setWindowIcon(QIcon(":/img/logo.png")); // set the program icon

    QQmlApplicationEngine engine;
    // create access to these objects from qml
    engine.rootContext()->setContextProperty("gImageProvider", gImageProvider);
    engine.rootContext()->setContextProperty("scheduler", &scheduler);
    engine.rootContext()->setContextProperty("nodeProvider", nodeProvider);
    engine.rootContext()->setContextProperty("fileIO", fileIO);

    engine.addImageProvider("gimg", gImageProvider);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));


    if (engine.rootObjects().isEmpty())
        return -1;
    return app.exec();
}
