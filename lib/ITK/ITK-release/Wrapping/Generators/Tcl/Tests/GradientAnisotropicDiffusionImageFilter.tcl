#==========================================================================
#
#   Copyright Insight Software Consortium
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#          http://www.apache.org/licenses/LICENSE-2.0.txt
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
#==========================================================================*/

#
#  Example on the use of the GradientAnisotropicDiffusionImageFilter
#
package require InsightToolkit

set reader [ itkImageFileReaderIF2_New ]
set writer [ itkImageFileWriterIUC2_New ]

set outputCast [ itkRescaleIntensityImageFilterIF2IUC2_New ]

set filter [ itkGradientAnisotropicDiffusionImageFilterIF2IF2_New ]

$filter     SetInput [ $reader  GetOutput ]
$outputCast SetInput [ $filter     GetOutput ]
$writer     SetInput [ $outputCast GetOutput ]


$reader SetFileName [lindex $argv 0]
$writer SetFileName [lindex $argv 1]


$outputCast SetOutputMinimum       0
$outputCast SetOutputMaximum   255

set numberOfIterations [expr [lindex $argv 2]]
set timeStep           [expr [lindex $argv 3]]
set conductance        [expr [lindex $argv 4]]


$filter SetNumberOfIterations     $numberOfIterations
$filter SetTimeStep               $timeStep
$filter SetConductanceParameter   $conductance


$writer Update


exit
