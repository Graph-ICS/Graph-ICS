#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QDebug>
//
#include <QQmlProperty>
//
#include "gimageprovider.h"
#include "gthread.h"
#include "nodeprovider.h"
#include "fileio.h"

#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui.hpp>

// Nodes
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


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_UseStyleSheetPropagationInWidgetStyles);
    QCoreApplication::setAttribute(Qt::AA_Use96Dpi);

    QGuiApplication app(argc, argv);

    GImageProvider* gImageProvider = new GImageProvider();
    GThread workerThread;
    NodeProvider* nodeProvider = new NodeProvider();
    FileIO* fileIO = new FileIO();

    app.setOrganizationName("Graph-ICS");
    app.setOrganizationDomain("https://github.com/Graph-ICS/Graph-ICS");

    // Funktioniert, aber in QML NodeView Fehlermeldung, da die Typen erst zur laufzeit registriert werden
    nodeProvider->registerNode<Video>("Video");
    nodeProvider->registerNode<Camera>("Camera");
    nodeProvider->registerNode<Image>("Image");


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


    // Singleton mit Konstanten
    qmlRegisterSingletonType(QUrl("qrc:/theme/Theme.qml"), "Theme", 1, 0, "Theme");

    qRegisterMetaType<cv::Mat>("cv::Mat");
    qRegisterMetaType<GImage>("GImage");

    app.setWindowIcon(QIcon(":/img/logo.png")); // Logo des Programmes setzen

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("gImageProvider", gImageProvider);
    engine.rootContext()->setContextProperty("workerThread", &workerThread);
    engine.rootContext()->setContextProperty("nodeProvider", nodeProvider);
    engine.rootContext()->setContextProperty("fileIO", fileIO);

    engine.addImageProvider("gimg", gImageProvider);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));


    if (engine.rootObjects().isEmpty())
        return -1;
    return app.exec();
}
