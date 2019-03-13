Graph-ICS
===

## Table of Contents
1. [Overview](#overview)
2. [Installation](#installation)
3. [User Guide](#user-guide)
4. [Developer Guide](#developer-guide)

## Overview

![Qt](https://img.shields.io/badge/Qt-5.11.0-green.svg) ![Itk-Kit](https://img.shields.io/badge/ITK-last%20version-blue.svg) ![OpenCv](https://img.shields.io/badge/OpenCV-last%20version-blue.svg) ![VisualStudio](https://img.shields.io/badge/Visual%20Studio%20compiler-2017-orange.svg) 

Graph-ICS is a software for image processing. It supports image filters using **[ITK](https://itk.org/)** and **[OpenCV](https://opencv.org/)**. Its user interface is based on  **[QML](http://doc.qt.io/qt-5/qtqml-index.html)** and **[QtQuick](http://doc.qt.io/qt-5/qtquick-index.html)**.

The user interface is basically divided into two parts: the canvas (drawing area) on the left and the viewer on the right. Via drag&drop  from the toolbar above you can draw nodes on the canvas. Nodes represent images or filters. 

Nodes can be connected to each other. So they can have input nodes on their left side and output nodes on their right side. Usually there is one image node input for a chain of filters.

The picture below shows an example:

<center>
	<img src="doc/overview.png" />
</center>

Via double-click on a node the corresponding output image will be calculated and shown on the right side by the viewer.

So if you double-click in the example below on "CVMedian" first the image "brain.jpg" will be  processed by a black/white filter, then by an (OpenCV) median filter and then the corresponding output image will be shown in the viewer. Otherwise if you double-click on "BlackWhite" only the black/white filter will be applied:

<center>
	<img src="doc/getResultExample.PNG" />
</center>

## Installation

With a successfully execution of the Installations guide steps you should be able to build and run the project.

**Note:** The project has been recently renamed from "GraphMIC" to "Graph-ICS". The screenshots shown in the installation guide may contain the old name of the project.  

Required components:

- Microsoft Windows 7, 8 or 10
- Visual Studio 2015 or Visual Studio 2017
- CMake
- Qt 5.11.0 with Qt Creator
- ITK
- OpenCV 3.x

**Please read the instructions carefully and pay attention to the complementary images.**

## Contents

1. Download Project from GitHub
2. Install Debugging Tools from the Windows SDK
3. Install Visual Studio 
4. Install CMake 
5. Install Qt 
6. Install and Build ITK 
7. Install and Build OpenCV   
8. Configure the Project (Graph-ICS)
9. (Optional) Change CMakeLists.txt file

### 1. Download the Project from GitHub
1.1. Go to https://github.com/Graph-ICS/Graph-ICS   

1.2. Click on "Clone or Download"  

1.3. Click on "Download ZIP"  

1.4. Unpack the file and save it at the project path of your choice, e.g. "D:\Graph-ICS"


### 2. Install Debugging Tools from the Windows SDK

Windows SDK contains a CDB Debugger. You will need it in case you want to debug the application. 

2.1. Go to https://www.microsoft.com/en-us/download/details.aspx?id=8279 in case you use Windows 7.

2.2. Click "Download".

2.3. Run the installer.

2.4. Read the licence and select "I Agree".

2.5. Click next.

2.6. Select option "Debugging Tools for Windows" as shown here and click next:

<center>
	<img src="doc/Readme_Installation/Installation1.PNG" />
</center>


## 3. Install Visual Studio

3.1. Go to https://visualstudio.microsoft.com/vs/community/
    
3.2. Ensure that "Windows" is selected then click download to download the installer:

<center>
	<img src="doc/Readme_Installation/Installation2.PNG" width="400" />
</center>

3.3. Go to the downloads folder, select the installer and run it as administrator.

3.4. Click continue.
    
3.5. Wait for the download, then select "Desktop development using C++" and click "Install":

<center>
	<img src="doc/Readme_Installation/Installation3.PNG" />
</center>

3.6. Restart you computer as requested after the installation.


## 4. Install CMake

4.1. Go to https://cmake.org/download/

4.2. Select installer of latest release, e.g. "cmake-3.13.4-win64-x64.msi"

4.3. Start the installer and follow its instructions.

4.4. Select "Add CMake to the system PATH for all users":

<center>
	<img src="doc/Readme_Installation/Installation4.PNG" width="400" />
</center>  

4.5. Finish setup.


## 5. Install Qt

5.1. Go to https://www.qt.io/download, select "Go open source" and then click "Download"

5.2. Run the installer, click on next, then skip, click next.

5.3. Select the path where you want to install Qt, e.g. "C:\Qt". Click next.

5.4. Select the components you want to install, the ones you need are:

- Below "Qt 5.11.0": select "MSVC 2017 64-bit"
- Below "Developer and Designer Tools": "Qt Creator 4.8.1 CDB Debugger Support"

5.5. Finish the installation.

5.6. Setting up the QT Creator (NMake Generator)

- Open QtCreator, go to "Tools" and click "Options":

<center>
	<img src="doc/Readme_Installation/Installation5.PNG" />
</center>

- Select "Kits".

- Select "Desktop Qt 5.11.0 MSVC 2017 64bit" and click "Clone":

<center>
	<img src="doc/Readme_Installation/Installation6.PNG" />
</center>

- Select the cloned kit, go to "CMake generator" and click "Change...":

<center>
	<img src="doc/Readme_Installation/Installation7.PNG" />
</center>

- Select "NMake MakeFiles JOM" as generator, and "CodeBlocks" as extra generator, then click "OK":

<center>
	<img src="doc/Readme_Installation/Installation8.PNG" />
</center>

- If you want to debug make sure you select the correct path to the debugger like on the following picture:

<center>
	<img src="doc/Readme_Installation/Installation9.PNG" />
</center>

- Click "OK" and close the Qt Creator.

5.7. Add Qt Creator, e.g. "C:\Qt\Tools\QtCreator\bin", to your system path. [Here](https://www.nextofwindows.com/how-to-addedit-environment-variables-in-windows-7) is described how that works in general.


## 6. Install and Build ITK

6.1. Create a target folder for ITK. We recommend "D:\lib\ITK".

**Note:** If you choose another folder you need to adjust CMake files later on.

**Note:** Do not choose a path wich is too long because CMake paths are restricted to 50 characters by default.

6.2. In your ITK folder create a subfolder "bin".

6.3. Go to https://github.com/InsightSoftwareConsortium/ITK

- Go to branches
- Select the branch “release”. On the right click on "Clone or download", then click "Download ZIP"
- Move the Zip file to your ITK folder, e.g. "D:\lib\ITK".
- Right-click the Zip file and select unzip it here, so it will be a folder “ITK-release” created.
    
6.4. Open CMake GUI

- On “Where is the source code” set the path to the unzipped “ITK-release” folder.
- On “Where to build the binaries” set the path to the "bin" folder you created before.
<center>
	<img src="doc/Readme_Installation/Installation10.PNG" />
</center>

- Click on "Configure" so on the pop-up window select “Visual Studio 15 2017 Win64” (see the image below, if you have Visual Studio 2015 select "Visual Studio 14 2015 Win64") as generator and click "finish". It will take a couple of minutes to configure the project.
<center>
	<img src="doc/Readme_Installation/Installation11.PNG" />
</center>

- The output window will tell you the configuring is done, so search for  the component BUILD_TESTING and uncheck it! then click on
    configure:
- The output window will tell you the configuring is done, so search for
    the component KWSTYLE and uncheck it! then click on configure
<center>
	<img src="doc/Readme_Installation/Installation12.PNG" />
</center>

- When the configuration is done, then click on generate, so it will generate a Visual studio project.

6.5. When it finishes the generation, run Visual Studio as administrator and open the project

6.6. On Visual Studio

- Wait until the project initializes and parses the files. (you can read it on the blue bar on the bottom)
<center>
	<img src="doc/Readme_Installation/Installation13.PNG" />
</center>

- Right-click on "CMakePredefinedTargets/ALL_BUILD" and click "build". It will take several minutes to complete the process.

- Make sure you make this step for both "Debug" and "Release" configuration.


## 7. Install and Build OpenCV:

To install and build OpenCV you can download and use the pre-compiled binaries and follow 7.1 (which is recommended) or you can build the binaries by yourself following 7.2 (wich takes much time).

<center>
	<img src="doc/Readme_Installation/Installation14.PNG" />
</center>

7.1. USING THE PROVIDED MSVC BINARIES:

- Go to https://opencv.org/releases.html

- Select "Win pack" of the latest 3.x.x version:

<center>
	<img src="doc/Readme_Installation/Installation15.PNG" />
</center>

- Open the download folder and start the just downloaded "opencv....exe".

- Set the path where you want to extract the package. We recommend "D:\lib".

- Extract the files.
    
7.2. BUILDING OF OPENCV BINARIES WITH MSVC ON YOUR OWN:
Follow the steps in section 6 and consider the following changes:

- For 6.1 we recommend the target folder "D:\lib\opencv".

- For 6.3 download OpenCC from https://opencv.org/releases.html, select "Sources" of the latest 3.x.x version.

- Move the Zip file to the OpenCV folder.

- Right-click on the Zip file and select unzip it here. The created subfolder is the source folder in 6.4.

- For 6.4 omit unchecking the KWSTYLE component on the CMake Configuration.    
    
    
## 8. Configure the Project (Graph-ICS)

8.1. Open Qt Creator and click "open project" on the "Welcome" tab.

8.2. Select "CMakeLists.txt" in the project path.

8.3. Of the shown project configurations select the kit you cloned in step 5.6 and click "Details". Then select "Default", "Debug" and "Release" and set a bin folder (output folder), e.g. "D:\Graph-ICS\bin":

<center>
	<img src="doc/Readme_Installation/Installation16.PNG" />
</center>

8.4. Click “configure project”


8.4. Make sure that the path is set to the bin folder of the project. You may have to create the folder first. If the path looks like the path in the image, go to the tab "Edit", right click on the project folder and select "Run Cmake"

8.5. (Optional)If you have another configuration and it fails, so make sure you
delete the created CMakeCache.txt in the bin folder and the
CMakeLists.txt.user on the source folder before you try it again.
<center>
	<img src="doc/Readme_Installation/Installation17.PNG" />
</center>

8.6. (This step can be optional if you add the opencv build directory to the
environment path variables) If the CMake don’t find the ITK or OpenCv
libraries automatically, then you will see the error on the common output tab
below like on the following image, so you must set the paths manually using
the CMake GUI:

- Open CMake Gui, set the Graph-ICS source folder and the binary folder, click on file and reload cache
<center>
	<img src="doc/Readme_Installation/Installation18.PNG" />
</center>

- CMake GUI and set the correct build path of the OpenCv directory on the  field OpenCv_Dir and click on configure
<center>
	<img src="doc/Readme_Installation/Installation19.PNG" />
</center>

- (Repeat the proces for ITK_Dir) Go back to Set the correct build path
    of the ITK directory on the field ITK_Dir and click on configure, click on reload cache.

- Go to Qt Creator, Edit tab and click on Run Cmake.
- (Optional)CMake might will throw an error, but the path should be already
    set, so you can ignore it.
    <center>
	<img src="doc/Readme_Installation/Installation20.PNG" />
</center>

- Close CMake GUI

8.7. Go to Qt Creator to the tab edit right-click on the project folder and run
CMake, the project should be configured jet and you will see all the folders
and files corresponding to the project on the left tab:

<center>
	<img src="doc/Readme_Installation/Installation21.PNG" />
</center>

8.8. You should be able to build and run the project, maybe you should restart the
Qt Creator und re-open it and the project from the recent used projects pane.
<center>
	<img src="doc/Readme_Installation/Installation22.PNG" />
</center>

8.9. If you want to debug the application in C++ and QML go to Projects,
and on the Run option, click on enable QML.

<center>
	<img src="doc/Readme_Installation/Installation23.PNG" />
</center>


## 10. (Optional) Change the CMakeLists.txt file

**This step is only necessary if you have installed ITK and OpenCV not unter D:\lib**  
10.1. In the opended project in the QtCerator go to the CMakeList.txt file and go to step 5: binding of libraries  

<center>
	<img src="doc/Readme_Installation/24.PNG" />
</center>  

10.2. In line 54 in the image change the path D:\\lib\\ITK\\bin to the path where you have installed the lib folder \<<yourPath\>>\lib\ITK\bin  
10.3. In line 59 in the image change the path D:\\lib\opencv\\build to your path \<<yourPath\>>\lib\opencv\build

## User Guide
- **Loading an image** <br /> 
In order to load an image you must create the node "Image". To do so, go to the combobox and select the item "Image" in the list view (1). by clicking the "Select" Button the node will be created (2).
You can either write the path to the image you want to edit in the text field or select it drom you file explorer by clicking the file symbol (3)

<center>
	<img src="doc/readme_loadAnImage.png" />
</center>

- **Adding a filter** <br />
If you have created an image you can execute a filter on it by creating a node according to the filter you want. Then connect the image with the filter by drawing an edge from the output from the image to the input of the filer. Double-click on the filer and the edited image will be shown in the viewer. This can also be done if you click right on the node and select "Show Image" in the context menu.
<center>
	<img src="doc/readme_addingAFilter.png" />
</center>

- **Removing an node** <br />
Right-cklicking on a node will open a context menu. Click "Remove Node".
<center>
	<img src="doc/readme_removingAnNode.png" />
</center>

- **Edit nodes** <br />
If you want to edit various nodes you can select them by drawing a rectangle on the canvas with your mouse (1).

<center>
	<img src="doc/readme_editNodes1.png" />
</center>

The selected nodes will be marked and you can perform differnet actions on them with the menu "Edit" (2)

<center>
	<img src="doc/readme_editNodes2.png" />
</center>

- Deleting all marked nodes: "Edit" -> "Remove Nodes"
- Copy all marked nodes: "Edit" -> "Copy" 
- Past the copied nodes: "Edit" -> "Paste" (you can also paste the selected nodes from one file to another)
- Duplicate: "Edit" -> "Duplicate" (Copy and Paste in one step) 
- Move all marked nodes: drag one of the selected nodes and move it with the mouse, the other nodes will also chage their position
- **Manage your Configuration** <br />
You can save your current confguration and open existing configurations at the menuitem "File". It is also possible to select an image from your filesystem which will be shown in the viewer.
<center>
	<img src="doc/readme_manageYourConfiguration1.png" />
</center>

These options are also available by clicking right on the canvas or viewer.
At the canvas:

<center>
	<img src="doc/readme_manageYourConfiguration2.png" />
</center>

At the viewer:

<center>
	<img src="doc/readme_manageYourConfiguration3.png" />
</center>

- **Favorites Toolbar** <br />
The programm allows to add filters to the toolbar. To do so, go to the combobox and right click on a filter. Select "Add To Favorites".

<center>
	<img src="doc/readme_favoritesToolbar1.png" />
</center>

The filterbutton is now available in the toolbar. Pressing on the filterbutton and moving the mouse inside the canvas will create the node at the requested position.
<center>
	<img src="doc/readme_favoritesToolbar2.png" />
</center>

The items in the toolbar can be rearranged by right cklicking and selecting "Move Item". Now you can drag the item with the mouse inside the toolbar.
You can delete the item from the toolbar with the context menu in the combobox or in the item itself

<center>
	<img src="doc/readme_favoritesToolbar3.png" />
</center>


## The diffenrent components of the programm are explained by the following figure:

<center>
	<img src="doc/readme_components.png" />
</center>



 1.	**Menu tab: There are different Menu Items:**

	1.1. **File:** you can manage your current file  
	<center>
	<img src="doc/File.PNG" />
	</center>
	

	- open a new configuration
  	- open a configuration from your file explorer
	- save your current configuration
	- save your current configuration and select the name and path
	- open an image in the viewer from your files
	- remove the image shown in the viewer
	- save the current image in your viewer
	- exit the programm

	1.2. **Edit:** you can remove selected Nodes, Copy, Paste and Duplicate them
	
	1.3. **View:** if only one node is selected you can either get the result or delete this node
	
	1.4. **Help:** Information: About us and licences 

	
2.	**Toolbar: You will find all available filters in the combobox. You can scroll to the filter you want and then click "Select" to create a filter. If you choose "Add to Favorites" the filter will be shown in the toolbar and you can drag the node to the position you want**
	
3.	**Canvas: you can drag the nodes here and draw the edges between them**
	
4.	**Viewer: If you double click on a node, you will see its result image (output) here**
	
5.	**Image node: This node is an image node, you can load images on it, writing the path of the image on the textbox, right click on it to show or delete.**	
	
6.	**Filter node: The filter node allows you to set parameters to the filter, you need to connect it to an image node to apply on it the filter, right click on it to show or delete.**	

7.	**Edge: To create an edge, you just must click on a node port, hold and drag with the mouse to the position you want to connect with.**	
## Developer Guide

Contents
1. About the structure  
1.1. QtQuick and QML  
1.2. C++ Model  
2. Creating a new filter node  
2.1. Choose the filter  
2.2. Adding a new C++ filter class  
2.3. Implementing the filter class  
2.4. Defining the filter class in the source file  
2.5. Register the class as QtQuick QML Object  
2.6. Create your QML file  
2.7. Update the toolbar buttons  

### 1. About the structure

The structure of Graph-ICS is divided on two components.

#### 1.1. QtQuick and QML
The QtQuick framework includes the QML declarative scripting language. QML Objects are useful for the interaction with the user, the Graph-ICS user interface is conceded on QML, in Graph-ICS it makes possible to:

- Represent filters and images using nodes the user can drag on the Editor
pane (using customs objects)  
- Create a data flow between the created nodes connecting them using edges.
Interact to mouse and key events like user inputs.  
- Allow the user to change the filter values on a filter node and apply the filter
with these new values by clicking on it.  
#### 1.2. C++ Model

Each filter node represents a C++ Class defined as **\<ClassName\>Filter** , each filter
class is registered as QML Object on the main function so it can be instantiated as
QML Object. For more information go [here](http://doc.qt.io/qt-5/qtqml-cppintegration-exposecppattributes.html)

A typical filter class declaration will be showed on the Figure 1 : Typical filter
declaration, here the ItkDiscreteGaussianFilter.

- The **Q_OBJECT** macro tells the compiler this class implements its owns
signals and slots, so the meta object compiler moc need to run at first  
- The **Q_PROPERTY** macro will be used to tell the compiler the variables to be
read through a given get method, write through a given set method and the
changes will be notified using the given method next the NOTIFY macro  
- The **Q_INVOKABLE** macro allows functions to be called from QML objects  

<center>
	<img src="doc/Readme_DeveloperGuide/1.PNG" />
</center>

*Figure 1 : Typical filter declaration, here the ItkDiscreteGaussianFilter class*
### 2. Creating a new filter node
To create a new filter object, it is needed to create a new filter class, register this
class as a QML object and add it into the window toolbar to make it visible for the
user. As example we want to add the *ITKMedianImageFilter* as follows:

#### 2.1. Choose the filter
- Go to the documentation page of the filter you want to implement, for OpenCv or
ITK (Another good website for ITK examples is <https://itk.org/Wiki/Main_Page> or
<https://itk.org/ItkSoftwareGuide.pdf>
- Read the documentation of the filter and check the input parameter you will
need.
- For our example filer the documentation can be visited at:
<https://itk.org/Doxygen/html/classitk_1_1MedianImageFilter.html>
#### 2.2. Adding a new C++ filter class
Open the project, if you open the project for first time, so follow the step 7 from the
installation guide. Open the QtCreator and select by the Welcome Tab, the
Graph-ICS project.

<center>
	<img src="doc/Readme_DeveloperGuide/2.PNG" />
</center>

- Go to the Source folder
- Go to the Filter folder
- Right click on the filter folder and click on **Add New...**

<center>
	<img src="doc/Readme_DeveloperGuide/3.PNG" />
</center>

- Select C++ Class, click on choose.
- Name the class like the filter you want to implement. (for example,
ItkMedianFilter), look at the existing classes and the names on camel case
- Click on finish.
- If you get a warning from Qt, ignore it
- Run CMake right clicking on the project folder and selecting “Run CMake”.

<center>
	<img src="doc/Readme_DeveloperGuide/4.PNG" />
</center>

- Now a both header und source files from your class are available on the
project pane.
#### 2.3. Implementing the filter class
- Go to the header file of your new class

- The filter classes are very similar only the filter parameters might change, so you can
define your class using the definition of an existing filter class

- For our example the median filter needs two parameters: m_radiusX and
m_radiusY, so we create these two variables on our class ItkMedianFilter, add its
get, set methods and Q_PROPERTIES.

<center>
	<img src="doc/Readme_DeveloperGuide/5.PNG" />
</center>

 *Figure 2 : ItkMedianFilter Class, implementation example*  

Consider the *Figure 2 : ItkMedianFilter Class, implementation example*. by
implementing your filter class, pay attention to the following steps:

1. The class should include the node.h header.
2. The class should inherit from the Node class as public.
3. The class should include the Q_OBJECT macro.
4. In case the filter you want to implement needs some input values, so you need
to create this input values as member variable.
5. Implement for each parameter variable the get and set methods.
6. Add a Notify Signal for each member variable you will use as parameter.
7. Add the Q_PROPERTIES for each member variable on the class, using its
get, set methods and signals. This will be needed to exchange data between
the model and the view on the QML site.
8. Implement the retrieveResult() function.


#### 2.4. Defining the filter class in the source file
- Go to the source file of your class.
- Define your constructor giving a default value for each input parameter (Look
at the documentation).
- Define the get and sets methods, make sure you call the function
cleanCache() on the set methods.

<center>
	<img src="doc/Readme_DeveloperGuide/6.PNG" />
</center>

- Override the virtual function retrieveResult() as follows:  
Consider the Figure 3 : itkmedianfilter.cpp, definition of retrieveResult(), the new class
needs also to overwrite the virtual function node::retrieveResult().

<center>
	<img src="doc/Readme_DeveloperGuide/7.PNG" />
</center>

*Figure 3 : itkmedianfilter.cpp, definition of retrieveResult()*

The filter will be implemented on the Try block. The definition of the
ItkMedianFilter::retrieveResult() function follows these 6 steps:

1. The first If clause will check if there is an input, so this input is an QPixmap, we
convert it on a QImage format to access to its pixels values. (line 37)
2. The second clause will check if the m_img variable is set (this variable holds the
input image), in this case the current value will be loaded. (line 38)
3. On the Try block, we get the image input, prepare the ITK filter with the proper
parameters: InputImageType, OutputImageType and ImageDimension. (line
43 - 50 )
4. We use the ImageConverter::itkImageFromQImage(TargetITKImage,
FromQImage) function to convert the input QImage to a ITK Image. (line 51 )
5. We create the ITK::MedianImageFilter pointer using the given InputImageType
and OutputImageType parameters from step 3 (line 53 - 54), and set the values
given from the user. (line 56 - 61)
6. The ITK Image output from filter will be converted to an QImage to
continue the data flow. (line 63)
7. In order to continue the flow between the nodes, we need to convert out filter
output to an QImage, so we call the
ImageConverter::qImageFromITKImage(TargetQImage, FromITKImage)
function. (line 65)
8. In case an exeption occurred, then it will be catched on the catch block. (line 69-72)
9. If the Filter was correct implemented, so the function retrieveResult() returns the
flag true.(line 74)  

Take care of the valid parameter types and values for your filter, the Figure 3 :
itkmedianfilter.cpp, definition of retrieveResult() shows the position where this
parameters might change for each ITK filter. The number 1 represent the input pixel
types and image dimension, the number 2 represents the ITK filter parameters.





#### 2.5. Register the class as QtQuick QML Object
Once we have already prepared the class following successfully the step 2 , so we
should register this class on the main.cpp file as QML Type, it will make possible to
use this class on QML files declaring it as normal QML Object.

So, we will need to add the following line to the code (take care of the used name
convetion):

<center>
	<img src="doc/Readme_DeveloperGuide/8.PNG" />
</center>

The syntax for this function should be as follows:

<center>
	<img src="doc/Readme_DeveloperGuide/9.PNG" />
</center>

Whit X, Y as the package version. We will always use the package version X= 1 and
Y = 0. Make sure you include your class header file, so we must add the line:

<center>
	<img src="doc/Readme_DeveloperGuide/10.PNG" />
</center>

#### 2.6. Create your QML file
In this step you should create a QML file on the QML project folder to be able to use
our filter class in our user interface.

- Right click on the QML/file folder, select Add new
- Select Qt, and QML File as the following image

<center>
	<img src="doc/Readme_DeveloperGuide/11.PNG" />
</center>

We turn into the QML coding, so we create a new file to hold the created class on the
QML folder, we name this file ITKMedian.qml, like the name of the filter you want to
create.

<center>
	<img src="doc/Readme_DeveloperGuide/12.PNG" />
</center>

*Figure 4 : Importing the needed components*

We add the showed import packages like on Figure 4 : Importing the needed
components to the top of the QML file.

qmlRegisterType< ItkMedianFilter >(" Model.ItkMedian ", 1 , 0 ," ItkMedian ");

qmlRegisterType< ClassName >(" Model.FilterName ",X,Y," FilterName ");

#include "itkmedianfilter.h"

For your class you need to change the line 6 , and import the filter name you
registered before on the step 2.5, the numbers following the import package are
taken as the package version.

If the Filter needs 2 inputs, you must instantiate an QML Object from the class
GFilter2Ports.qml as parent, so just write GFilter2Ports on line 8.

If the Filter needs 3 inputs you must instantiate the parent GFilter 3 Ports.qml, so
write GFilter 3 Ports.

If your filter just need one input, so use the GFilter object as you see on the Figure 5 :
Filter object on QML..

For the median filter we just need one input, this will contain all the needed
implementations for a basic node (dragging, connections through edges...), so we
use the GFilter object.

Inside this GFilter Object, you need to create an instance of your filter class (lines
14 - 16 ) with the id: model and a property alias to the model (line 1 8 ) like on the
Figure 5 : Filter object on QML.

<center>
	<img src="doc/Readme_DeveloperGuide/13.PNG" />
</center>

*Figure 5 : Filter object on QML.*

Create a Label to hold the filter name, for us “ITKMedian”.

Create a Label and a TextField for each input parameter your filter needs, the Label
just holds the parameter name and the TextField will contain the parameter value,
make sure you give each TextField a valid id.

For us, the ItkMedian needs two inputs: RadiusX and RadiusY, so we created the
corresponding labels and textfields.

<center>
	<img src="doc/Readme_DeveloperGuide/14.PNG" />
</center>

*Figure 6 : TextField for an input parameter*

Consider the Figure 6 : TextField for an input parameter, for each input parameter,
you should create a TextField like this for each input parameter, it is recommended
to use the parameter name as id (line 29), its text property should hold the
parameter value from your filter class model (line 42), the onTextChanged event
should be implemented changing the model parameter every time the TextField text
changes (Lines 45- 47 ).

<center>
	<img src="doc/Readme_DeveloperGuide/15.PNG" />
</center>

*Figure 7 : Parameter name “RadiusY”, represented with a Label*


The parameter name for the TextField radius, will be showed using a Label, see
Figure 7 : Parameter name “RadiusY”, represented with a Label.

<center>
	<img src="doc/Readme_DeveloperGuide/16.PNG" />
</center>

*Figure 8 : Designer view of the ITKMedianFilter.qml*

If you click on the left pane, on the Design tab you can see the result of your code,
like on the Figure 8 : Designer view of the ITKMedianFilter.qml.
The design does not look ecaxtly like this in the programm but you can see the size of the node and the position of the labels. 


The last step consist on implementing two functions saveNode() and loadNode() its
implementation are same for each filter, but the ids might vary. If the filter you want
to implement have no input parameters, you don’t need to implement these
functions.

<center>
	<img src="doc/Readme_DeveloperGuide/17.PNG" />
</center>

*Figure 9 : ITKMedianFilter.qml, functions saveNode() and loadNode()*

Consider the Figure 9 : ITKMedianFilter.qml, functions saveNode() and loadNode(),
the lines 84- 87 und 90 are same for each filter node, the next lines 88-89 will vary
depending on the input parameters and the TextField id’s.

On the function loadNode(), we will read the values from the saved nodeData JSON
object and load it into the TextFields representing the saved configuration values.

2.7. Update the toolbar buttons
On the GToolBar.qml go to the ListModel and add your filter as a new ListElement
object, see Figure 10 : ListModel and ListElements.

The name of the new ListElement should be exactly the name of the QML file you
created without the .qml ending.

<center>
	<img src="doc/Readme_DeveloperGuide/18.PNG" />
</center>

*Figure 10 : ListModel and ListElements*
