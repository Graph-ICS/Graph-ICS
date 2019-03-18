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

### Contents

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


### 3. Install Visual Studio

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


### 4. Install CMake

4.1. Go to https://cmake.org/download/

4.2. Select installer of latest release, e.g. "cmake-3.13.4-win64-x64.msi"

4.3. Start the installer and follow its instructions.

4.4. Select "Add CMake to the system PATH for all users":

<center>
	<img src="doc/Readme_Installation/Installation4.PNG" width="400" />
</center>  

4.5. Finish setup.


### 5. Install Qt

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


### 6. Install and Build ITK

6.1. Go to https://github.com/InsightSoftwareConsortium/ITK

- Select the branch “release”. 
- Click on"Clone or download", 
- Click on"Download ZIP"
    
6.2. Create a target folder for ITK. We recommend "D:\lib\ITK".

**Note:** If you choose another folder you need adjust a CMake file later on.

**Note:** Do not choose a path wich is too long because CMake paths are restricted to 50 characters by default.

- Unzip the downloaded file in your ITK folder, so a subfolder “ITK-release” will be created.

- In your ITK folder create a subfolder "bin".

6.3. Open CMake GUI

- On “Where is the source code” set the path to the “ITK-release” folder.

- On “Where to build the binaries” set the path to the "bin" folder.

<center>
	<img src="doc/Readme_Installation/Installation10.PNG" />
</center>

- Click on "Configure".

- A window will pop up. Specify the generator with “Visual Studio 15 2017 Win64” and click "Finish":

<center>
	<img src="doc/Readme_Installation/Installation11.PNG" />
</center>

- (You can ignore the error about "KWStyle".) Uncheck "BUILD_TESTING".

- Click on "Configure" again until there is no more red value, i.e. changed value.

- Click "Generate".

6.5. Run Visual Studio as administrator and open the generated project in your bin folder.

6.6. On Visual Studio

- Wait until the project is initialized. (See blue progress bar below)

- Right-click on "CMakePredefinedTargets/ALL_BUILD" and click "build". It will take several minutes to complete the process.

- Make sure you make this step for both "Debug" and "Release" configuration.


### 7. Install and Build OpenCV:

To install and build OpenCV you can download and use the pre-compiled binaries and follow 7.1 (which is recommended) or you can build the binaries by yourself following 7.2 (wich takes much time).

7.1. USING THE PROVIDED MSVC BINARIES:

- Go to https://opencv.org/releases.html

- Select "Win pack" of the **latest 3.x.x** version:

<center>
	<img src="doc/Readme_Installation/Installation15.PNG" />
</center>

- Open the download folder and start the just downloaded "opencv....exe".

- Set the path where you want to extract the package. We recommend "D:\lib".

- Extract the files.
    
7.2. BUILDING OF OPENCV BINARIES WITH MSVC ON YOUR OWN:
Follow the steps in section 6 and consider the following changes:

- For 6.1 download OpenCV from https://opencv.org/releases.html, select "Sources" of the latest 3.x.x version.

- For 6.2 we recommend the target folder "D:\lib\opencv". Unzip the downloaded file in that folder. The created subfolder is the source folder in 6.3.

    
### 8. Configure the Project (Graph-ICS)

8.1. If ITK or OpenCV is not installed at the default path which is "D:\lib\ITK\bin" and "D:\lib\opencv\build":

- Open "CMakeLists.txt" in the project path:

<center>
	<img src="doc/Readme_Installation/24.PNG" />
</center>  

- Search for "ITK_DIR" and adjust the set path.

- Search for "OpenCv_DIR" and adjust the set path.
 
- Save and close the file.

8.2. Open Qt Creator and click "open project" on the "Welcome" tab.

8.3. Select "CMakeLists.txt" in the project path.

8.4. Of the shown project configurations select the kit you cloned in step 5.6 and click "Details". Then select "Default", "Debug" and "Release" and set a bin folder (output folder), e.g. "D:\Graph-ICS\bin":

<center>
	<img src="doc/Readme_Installation/Installation16.PNG" />
</center>

8.5. Click “configure project”


## User Guide

- ### Add an image

In order to add an image you must create an "Image" node. To do so, go to the combobox and select the item "Image" in the list view (1). By Drag&Drop from the "Select" Button the node will be created where you release the mouse button (2).
You can either write the path to the image you want to edit in the text field or select it drom you file explorer by clicking the file symbol (3).

<center>
	<img src="doc/readme_loadAnImage.png" />
</center>

- ### Add and apply filters

If you have created an image you can apply a filter on it. Create any filter node as you created the image node. Then connect your image (or your previous filter) with the filter by drawing an edge from the (right) output port to a filter's (left) input port. Double-click on the filer and the filtered image will be shown in the viewer. This can also be done if you right-click on the node and select "Show Image" its context menu.

<center>
	<img src="doc/readme_addingAFilter.png" />
</center>

- ### Remove nodes

Right-click on a node and select "Remove Node".

<center>
	<img src="doc/readme_removingAnNode.png" />
</center>

- ### Edit several nodes at once

If you want to edit several nodes you can select them by drawing a rectangle on the canvas with your mouse.

<center>
	<img src="doc/readme_editNodes1.png" />
</center>

The selected nodes will be marked and you can perform different actions on them using the "Edit" menu.

<center>
	<img src="doc/readme_editNodes2.png" />
</center>

- ### Manage your configuration

You can open and save a configuration of nodes via the "File" menu. It is also possible to select an image from your filesystem to show it the viewer.

<center>
	<img src="doc/readme_manageYourConfiguration1.png" />
</center>

These options also works via the context menu of the canvas:

<center>
	<img src="doc/readme_manageYourConfiguration2.png" />
</center>

...or of the viewer:

<center>
	<img src="doc/readme_manageYourConfiguration3.png" />
</center>

- ### Favorites toolbar

Graph-ICS allows adding filters to the toolbar. To do so go to the combobox, right click on a node and select "Add To Favorites".

<center>
	<img src="doc/readme_favoritesToolbar1.png" />
</center>

Via Drag&Drop from a node in the toolbar a corresponding node will be created in the canvas.

<center>
	<img src="doc/readme_favoritesToolbar2.png" />
</center>

You can delete an item from the toolbar via its context menu item "Remove From Favorites" (1).
Via context menu you can also rearrange items within the toolbar by selecting "Move Item" (2). So you can drag an item with your mouse inside the toolbar.

<center>
	<img src="doc/readme_favoritesToolbar3.png" />
</center>


## Developer Guide

Graph-ICS supports to add your own filters. To create a new filter it is needed to create a filter class (the model), register this
class as a QML object, define a corresponding view via QML (using the model) and adding this to the toolbar to make it visible for the user. The following steps show this in detail based on the example *ITKMedianImageFilter*.


### 1. Choose filter

- Go to the documentation page of the filter you want to implement (for OpenCv: https://docs.opencv.org/, for ITK: https://itk.org/Wiki/Main_Page or https://itk.org/ItkSoftwareGuide.pdf)
- Here is the documentation of our example filter: https://itk.org/Doxygen/html/classitk_1_1MedianImageFilter.html


### 2. Add a new filter class

- (Open the project in the Qt Creator)
- Right-click on "Sources/Filter" and select "Add New...":

<center>
	<img src="doc/Readme_DeveloperGuide/3.PNG" />
</center>

- Select "C++", "C++ Class" and click on "choose".
- Enter a class name, e.g. "ItkMedianFilter".
- Click "next", then "finish".
- Ignore CMake warning.
- Right-click on project node and select “Run CMake”:

<center>
	<img src="doc/Readme_DeveloperGuide/4.PNG" width="500" />
</center>


### 3. Implement filter class

The structure of filter classes are quite similar. So you can orient on predefined filters. 

- Open the header header file of your new filter:

<center>
	<img src="doc/Readme_DeveloperGuide/5.PNG" />
</center>

- Pay attention to the following steps:

    (1) Include "node.h".
    
    (2) Inherit from the Node class.
    
    (3) Use Q_OBJECT macro with the class.
    
    (4) Declare member variables per input parameter of the filter.
    
    (5) Declare a pair of get and set method per input parameter.
    
    (6) Add a Signal per input parameter.
    
    (7) Add a Q_PROPERTY per input parameter referring member variable, get method, set method and signal. This is needed for the interaction between QML view and C++ model.
    
    (8) retrieveResult() is a pure virtual function of the base class. So it must be implemented and it shall contain the actual filter functionality.

- Now go to the source file of the new filter.
- Implement a default constructor by giving a default value for each member variable.
- Define the get and set methods.
- With the set methods ensure you call cleanCache() in case of real changes. In that case a reevaluation of a nodes leads to the call of retrieveResult() instead of using the possibly cached image:

<center>
	<img src="doc/Readme_DeveloperGuide/6.PNG" />
</center>

- Implement retrieveResult() by following the next code listing:

<center>
	<img src="doc/Readme_DeveloperGuide/7.PNG" />
</center>

- Please consider those aspects:
    - m_img is inherited. It is the possibly cached image of a node.
    - So first we check if the (one) input node is not set or their is a cached image (lines 37 - 40). Then no "(re)calculation" needs to be done. 
    - If this is not the case we proceed the actual filter (42 - 74).
    - Worth mentioning is line 67 where we define our result value and our new cached image, respectively.
    - In case of an error we return "false" (see line 71) otherwise we return "true".


### 4. Register filter as QML Object

- In "main.cpp" add the the following code to the main function in which "1" and "0" indicates major and minor version of the filter:

<center>
	<img src="doc/Readme_DeveloperGuide/8.PNG" />
</center>

- Furthermore in "main.cpp" include the corresponding filter header:

<center>
	<img src="doc/Readme_DeveloperGuide/10.PNG" />
</center>

### 5. Create your QML file

- Right-click on the QML/Filterand select "Add New...".
- Select "Qt", "QML File" and click on "choose":

<center>
	<img src="doc/Readme_DeveloperGuide/11.PNG" />
</center>

- Enter a name, e.g. "ItkMedianFilter".
- Click "next", then "finish".
- Right-click on project node and select “Run CMake”.
- Open new file and provide all needed imports while the last one is the just created and registered model class:

<center>
	<img src="doc/Readme_DeveloperGuide/12.PNG" />
</center>

- A filter view is represented by a "GFilter" object (in case your filter has 2 input ports then "GFilter2Ports" for 3 take "GFilter3Ports"):

<center>
	<img src="doc/Readme_DeveloperGuide/13.PNG" />
</center>

- Within the filter we need esp. an instance of the corresponding model object, e.g. "ItkMedian".

- Usually you define a label for the filter title.

- For a property you might want to use a "TextField". Please consider esp. the references to the model in line 42 and 46:

<center>
	<img src="doc/Readme_DeveloperGuide/14.PNG" />
</center>

- A label field for your property could be defined like this:

<center>
	<img src="doc/Readme_DeveloperGuide/15.PNG" />
</center>

- The resulting filter node for ITKMedian with its two parameters could look like this:

<center>
	<img src="doc/Readme_DeveloperGuide/16.PNG" />
</center>

- In order to support persisting node configurations still the two functions saveNode() and loadNode() must be implemented:

<center>
	<img src="doc/Readme_DeveloperGuide/17.PNG" />
</center>


### 6. Update the toolbar

- In GToolBar.qml go to the ListModel and add your filter as a new ListElement:

<center>
	<img src="doc/Readme_DeveloperGuide/18.PNG" />
</center>

