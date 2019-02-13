/*=========================================================================
 *
 *  Copyright Insight Software Consortium
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0.txt
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *=========================================================================*/

//
// This is an example of the itk::BayesianClassifierInitializationImageFilter.
// The example's goal is to serve as an initializer for the
// BayesianClassifier.cxx example also found in this directory.
//
// This example takes an input image (to be classified) and generates membership
// images. The membership images determine the degree to which each pixel
// belongs to a class.
//
// The membership image generated by the filter is an
// itk::VectorImage, (with pixels organized as follows: For a 2D image,
// its essentially a 3D array on file with DataType[y][x][c] where c is the
// number of classes and DataType is the template parameter of the filter
// (defaults to float). For a 3D image, it will be organized as
// Datatype[z][y][x][c])
//
// The example also optionally takes in two more arguments, as a convenience to
// the user. These arguements extract the specified component 'c' from the
// membership image and rescale, so the user can fire up a typical image
// viewer and see the relative pixel memberships to class 'c'.
//
// Example args:
//   BrainProtonDensitySlice.png Memberships.mhd 4  2 Class2.png
//
// Here Memberships.mhd will be a 2x2x4 image containing pixel memberships
// Class2.png shows pixel memberships to the third class, (rescaled for display)
//
// Notes:
//   The default behaviour of the filter is to generate memberships by centering
// gaussian density functions around K-means of the pixel intensities in the
// image. The filter allows you to specify your own membership functions as well.
//

#include "itkImage.h"
#include "itkBayesianClassifierInitializationImageFilter.h"
#include "itkImageFileReader.h"
#include "itkImageFileWriter.h"
#include "itkRescaleIntensityImageFilter.h"
#include "itkImageRegionConstIterator.h"

int main(int argc, char *argv[])
{

  constexpr unsigned int Dimension = 2;
  if( argc < 4 )
    {
    std::cerr << "Usage arguments: InputImage MembershipImage numberOfClasses [componentToExtract ExtractedImage]" << std::endl;
    std::cerr << "  The MembershipImage image written is a VectorImage, ( an image with multiple components ) ";
    std::cerr << "Given that most viewers can't see vector images, we will optionally extract a component and ";
    std::cerr << "write it out as a scalar image as well." << std::endl;
    return EXIT_FAILURE;
    }

  using ImageType = itk::Image< unsigned char, Dimension >;
  using BayesianInitializerType = itk::BayesianClassifierInitializationImageFilter<ImageType>;
  BayesianInitializerType::Pointer bayesianInitializer
                                          = BayesianInitializerType::New();

  using ReaderType = itk::ImageFileReader< ImageType >;
  ReaderType::Pointer reader = ReaderType::New();
  reader->SetFileName( argv[1] );

  try
    {
    reader->Update();
    }
  catch( itk::ExceptionObject & excp )
    {
    std::cerr << "Exception thrown " << std::endl;
    std::cerr << excp << std::endl;
    return EXIT_FAILURE;
    }

  bayesianInitializer->SetInput( reader->GetOutput() );
  bayesianInitializer->SetNumberOfClasses( atoi( argv[3] ) );

  // TODO add test where we specify membership functions

  using WriterType = itk::ImageFileWriter<BayesianInitializerType::OutputImageType>;
  WriterType::Pointer writer = WriterType::New();
  writer->SetInput( bayesianInitializer->GetOutput() );
  writer->SetFileName( argv[2] );

  try
    {
    bayesianInitializer->Update();
    }
  catch( itk::ExceptionObject & excp )
    {
    std::cerr << "Exception thrown " << std::endl;
    std::cerr << excp << std::endl;
    return EXIT_FAILURE;
    }

  try
    {
    writer->Update();
    }
  catch( itk::ExceptionObject & excp )
    {
    std::cerr << "Exception thrown " << std::endl;
    std::cerr << excp << std::endl;
    return EXIT_FAILURE;
    }

  if( argv[4] && argv[5] )
    {
    using MembershipImageType = BayesianInitializerType::OutputImageType;
    using ExtractedComponentImageType = itk::Image< MembershipImageType::InternalPixelType,
                        Dimension >;
    ExtractedComponentImageType::Pointer extractedComponentImage =
                                    ExtractedComponentImageType::New();
    extractedComponentImage->CopyInformation(
                          bayesianInitializer->GetOutput() );
    extractedComponentImage->SetBufferedRegion( bayesianInitializer->GetOutput()->GetBufferedRegion() );
    extractedComponentImage->SetRequestedRegion( bayesianInitializer->GetOutput()->GetRequestedRegion() );
    extractedComponentImage->Allocate();
    using ConstIteratorType = itk::ImageRegionConstIterator< MembershipImageType >;
    using IteratorType = itk::ImageRegionIterator< ExtractedComponentImageType >;
    ConstIteratorType cit( bayesianInitializer->GetOutput(),
                     bayesianInitializer->GetOutput()->GetBufferedRegion() );
    IteratorType it( extractedComponentImage,
                     extractedComponentImage->GetLargestPossibleRegion() );

    const unsigned int componentToExtract = atoi( argv[4] );
    cit.GoToBegin();
    it.GoToBegin();
    while( !cit.IsAtEnd() )
      {
      it.Set(cit.Get()[componentToExtract]);
      ++it;
      ++cit;
      }

    // Write out the rescaled extracted component
    using OutputImageType = itk::Image< unsigned char, Dimension >;
    using RescalerType = itk::RescaleIntensityImageFilter<
      ExtractedComponentImageType, OutputImageType >;
    RescalerType::Pointer rescaler = RescalerType::New();
    rescaler->SetInput( extractedComponentImage );
    rescaler->SetOutputMinimum( 0 );
    rescaler->SetOutputMaximum( 255 );
    using ExtractedComponentWriterType = itk::ImageFileWriter<OutputImageType>;
    ExtractedComponentWriterType::Pointer
               rescaledImageWriter = ExtractedComponentWriterType::New();
    rescaledImageWriter->SetInput( rescaler->GetOutput() );
    rescaledImageWriter->SetFileName( argv[5] );
    rescaledImageWriter->Update();
    }

  return EXIT_SUCCESS;
}
