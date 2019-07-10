#include "itkVectorGradientAnisotropicDiffusionImageFilter.h"
#include "itkVectorGradientMagnitudeImageFilter.h"
#include "itkWatershedImageFilter.h"

#include "itkImageFileReader.h"
#include "itkImageFileWriter.h"
#include "itkVectorCastImageFilter.h"
#include "itkScalarToRGBPixelFunctor.h"

#include "itkwatershedfilter.h"
#include "imageconverter.h"

ItkWatershedFilter::ItkWatershedFilter()
{
    m_threshold = 0.0;
    m_level = 0.0;
}

double ItkWatershedFilter::getLevel() const
{
    return m_level;
}

double ItkWatershedFilter::getThreshold() const
{
    return m_threshold;
}

void ItkWatershedFilter::setLevel(double value)
{
    if (value == m_level)
        return;

    m_level = value;
    cleanCache();
    emit levelChanged();
}

void ItkWatershedFilter::setThreshold(double value)
{
    if (value == m_threshold)
        return;

    m_threshold = value;
    cleanCache();
    emit thresholdChanged();
}

bool ItkWatershedFilter::retrieveResult()
{
    if (m_inNodes.size() < 1) {
        return false;
    }
    else {
        try {
            m_img = m_inNodes[0]->getResult();
            QImage img = m_img.toImage();
            /*
            constexpr unsigned int imageDimension = 2;

            using RGBAPixelType = itk::RGBAPixel< unsigned char >;
            using RGBAImageType = itk::Image< RGBAPixelType, imageDimension>;
            using VectorPixelType = itk::Vector< float, 4 >;
            using VectorImageType = itk::Image< VectorPixelType, imageDimension>;
            using LabeledImageType = itk::Image< itk::IdentifierType, imageDimension>;
            using ScalarImageType = itk::Image< float, imageDimension>;

            using InputImageType = itk::ImageFileReader< RGBAImageType >;
            using CastFilterType = itk::VectorCastImageFilter< RGBAImageType, VectorImageType >;
           //smooth the image
            using DiffusionFilterType = itk::VectorGradientAnisotropicDiffusionImageFilter<VectorImageType, VectorImageType >;
           //generate the height function
            using GradientMagnitudeFilterType =itk::VectorGradientMagnitudeImageFilter<VectorImageType>;
            using WatershedFilterType = itk::WatershedImageFilter<ScalarImageType>;

            CastFilterType::Pointer caster = CastFilterType::New();

            //first step pipeline
            DiffusionFilterType::Pointer diffusion = DiffusionFilterType::New();
            diffusion->SetNumberOfIterations(5);
            diffusion->SetConductanceParameter(1.0);
            diffusion->SetTimeStep(0.125);

            GradientMagnitudeFilterType::Pointer
            gradient = GradientMagnitudeFilterType::New();
            gradient->SetUsePrincipleComponents(0);

            WatershedFilterType::Pointer watershed = WatershedFilterType::New();
            watershed->SetLevel(level);
            watershed->SetThreshold(threshold);

            using ColorMapFunctorType = itk::Functor::ScalarToRGBPixelFunctor<unsigned long>;
            using ColorMapFilterType = itk::UnaryFunctorImageFilter<LabeledImageType, RGBAImageType, ColorMapFunctorType>;
            ColorMapFilterType::Pointer colormapper = ColorMapFilterType::New();

            InputImageType::Pointer itkInputImage = InputImageType ::New();
            ImageConverter::itkImageFromQImage_RGBA(itkInputImage, img);

            caster->SetInput(itkInputImage);
            diffusion->SetInput(caster->GetOutput());
            gradient->SetInput(diffusion->GetOutput());
            watershed->SetInput(gradient->GetOutput());
            colormapper->SetInput(watershed->GetOutput());

            itkInputImage = colormapper->GetOutput();

            ImageConverter::qImageFromITKImage_RGBA(itkInputImage, img);
*/
            m_img = QPixmap::fromImage(img);

        } catch (int e) {
            qDebug() << "ItkMedianFilter. Exception Nr. " << e << '\n';
            return false;
        }
    }
    return true;
}
