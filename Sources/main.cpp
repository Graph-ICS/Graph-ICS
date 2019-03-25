#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QDebug>
//
#include <QQmlProperty>
//
#include "gimageprovider.h"
#include "image.h"

#include "qtblackwhitefilter.h"
#include "qtdarkerfilter.h"
#include "qtlighterfilter.h"
#include "itkmedianfilter.h"
#include "itkdiscretegaussianfilter.h"
#include "itkcannyedgedetectionfilter.h"
#include "itkbinarymorphclosingfilter.h"
#include "itkbinarymorphopeningfilter.h"
#include "itksubstractfilter.h"
#include "cvmedianfilter.h"
#include "cvsobeloperatorfilter.h"

#include "itkwatershedfilter.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_UseStyleSheetPropagationInWidgetStyles);
    QCoreApplication::setAttribute(Qt::AA_Use96Dpi);

    QGuiApplication app(argc, argv);

    qmlRegisterType<Image>("Model.Image", 1, 0, "Image_Model");
    qmlRegisterType<QtBlackWhiteFilter>("Model.QtBlackWhiteFilter", 1, 0, "QtBlackWhiteFilter");
    qmlRegisterType<QtDarkerFilter>("Model.QtDarkerFilter", 1, 0, "QtDarkerFilter");
    qmlRegisterType<QtLighterFilter>("Model.QtLighterFilter", 1, 0, "QtLighterFilter");
    qmlRegisterType<ItkMedianFilter>("Model.ItkMedian", 1, 0, "ItkMedian");
    qmlRegisterType<ItkDiscreteGaussianFilter>("Model.ItkDiscreteGaussian", 1, 0, "ItkDiscreteGaussian");
    qmlRegisterType<ItkCannyEdgeDetectionFilter>("Model.ItkCannyEdgeDetection", 1, 0, "ItkCannyEdgeDetection");
    qmlRegisterType<ItkBinaryMorphClosingFilter>("Model.ItkBinaryMorphClosing", 1, 0, "ItkBinaryMorphClosing");
    qmlRegisterType<ItkBinaryMorphOpeningFilter>("Model.ItkBinaryMorphOpening", 1, 0, "ItkBinaryMorphOpening");
    qmlRegisterType<ItkSubstractFilter>("Model.ItkSubstract", 1, 0, "ItkSubstract");
    qmlRegisterType<CvMedianFilter>("Model.CvMedianFilter", 1, 0, "CvMedianFilter");
    qmlRegisterType<CvSobelOperatorFilter>("Model.CvSobelOperator", 1, 0, "CvSobelOperator");
    qmlRegisterType<ItkWatershedFilter>("Model.ItkWatershed", 1, 0, "ItkWatershed");


    GImageProvider* gImageProvider = new GImageProvider();

    app.setWindowIcon(QIcon("doc/Logo.png")); // Logo des Programmes setzen
    qDebug() << app.applicationDirPath();



    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("gImageProvider", gImageProvider);
    engine.addImageProvider("gimg", gImageProvider);
    engine.load(QUrl(QStringLiteral("QML/main.qml")));


    if (engine.rootObjects().isEmpty())
        return -1;
    return app.exec();
}
