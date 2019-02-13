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

#ifndef itkImageToRGBVTKImageFilter_h
#define itkImageToRGBVTKImageFilter_h

#include "itkProcessObject.h"
#include "vtkSmartPointer.h"
#include "vtkImageData.h"

namespace itk
{
/** \class ImageToRGBVTKImageFilter
 * \brief Converts an ITK image into a VTK image.
 *
 * \ingroup ITKLevelSetsv4Visualization
 */
template< typename TInputImage >
class ITK_TEMPLATE_EXPORT ImageToRGBVTKImageFilter:public ProcessObject
{
public:
  ITK_DISALLOW_COPY_AND_ASSIGN(ImageToRGBVTKImageFilter);

  /** Standard class type aliases. */
  using Self = ImageToRGBVTKImageFilter;
  using Superclass = ProcessObject;
  using Pointer = SmartPointer< Self >;
  using ConstPointer = SmartPointer< const Self >;

  /** Method for creation through the object factory. */
  itkNewMacro(Self);

  /** Run-time type information (and related methods). */
  itkTypeMacro(ImageToRGBVTKImageFilter, ProcessObject);

  /** Some type alias. */
  using InputImageType = TInputImage;
  using InputImagePointer = typename InputImageType::ConstPointer;
  using InputRegionType = typename InputImageType::RegionType;
  using InputSpacingType = typename InputImageType::SpacingType;
  using InputSizeType = typename InputImageType::SizeType;
  using InputPixelType = typename InputImageType::PixelType;
  using InputIndexType = typename InputImageType::IndexType;

  /** Get the output in the form of a vtkImage.
      This call is delegated to the internal vtkImageImporter filter  */
  vtkSmartPointer< vtkImageData >  GetOutput() const;

  /** Set the input in the form of an itk::Image */
  using Superclass::SetInput;
  void SetInput(const InputImageType *);

  /** This call delegate the update to the importer */
  void Update() override;

protected:
  ImageToRGBVTKImageFilter();
  ~ImageToRGBVTKImageFilter() override;

private:
  InputImagePointer               m_Input;
  vtkSmartPointer< vtkImageData > m_Output;
};
} // end namespace itk

#ifndef ITK_MANUAL_INSTANTIATION
#include "itkImageToRGBVTKImageFilter.hxx"
#endif

#endif
