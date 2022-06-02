set(INPUT_NODES Image Video Camera)

set(OUTPUT_NODES DiagramView ImageView)

set(GENERIC_NODES Dummy)

set(ITK_NODES ItkBinaryMorphClosing ItkBinaryMorphOpening ItkCannyEdgeDetection
              ItkDiscreteGaussian ItkSubtract ItkMedian)

set(OPENCV_NODES
    CvDilation
    CvErosion
    CvFourierTransformPSD
    CvHistogramCalculation
    CvHistogramEqualization
    CvMedian
    CvTransformation
    CvSobelOperator)

set(QT_NODES QtBlackWhite QtDarker QtLighter)
