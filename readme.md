Graph-ICS 0.8
Test
===

![Qt](https://img.shields.io/badge/Qt-5.11.0-green.svg) ![Itk-Kit](https://img.shields.io/badge/ITK-last%20version-blue.svg) ![OpenCv](https://img.shields.io/badge/OpenCV-last%20version-blue.svg) ![VisualStudio](https://img.shields.io/badge/Visual%20Studio%20compiler-2017-orange.svg) 

GraphMIC is a **[CMake](https://cmake.org)** project for image processing, it uses   **[QML](http://doc.qt.io/qt-5/qtqml-index.html)** and **[QtQuick](http://doc.qt.io/qt-5/qtquick-index.html)** for implementing the user interface.
The **[ITK](https://itk.org/)** and **[OpenCV](https://opencv.org/)** Libraries and filters are used as well. 

## User guide


Graph-ICS is a tool for image processing and uses nodes to represent filters and images. Each node has an input and an output, which are images. 
Double clicking on a node will shows you the output of this node on the right window site.
By creating edges between the nodes you can create a workflow between the nodes. 

You can also concatenate nodes connecting the output of a filter node with the input of another one.

<center>
	<img src="doc/overview.png" />
</center>

The programm is devided in two parts: the canvas (drawing area) and the viewer. Inside the canvas the user is able to create nodes and connect them. if he double-cklicks on one node the output will be shown in the viewer on the right side.




Example: 
<center>
	<img src="doc/getResultExample.PNG" />
</center>
The user creates the node "Image" and selects a image file from his file system by clicking on the file symbol. To add the Black-White-Filter he creates the related node and connects the two nodes by drawing an edge between them. The output of the Black-White node is now the editet picture. This can be repaeted as often as required. the output of the last filer (CVMedian) is the image which was loaded from the user with two filter operations. 




## Tutorial
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
The filterbutton is now available in the toolbar. Pressing on the filterbutton and moving the mouse inside the canvas will create the node at the requested position.
The items in the toolbar can be rearranged by right cklicking and selecting "Move Item". Now you can drag the item with the mouse inside the toolbar.
You can delete the item from the toolbar with the context menu in the combobox or in the item itself

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


License
![License](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.


THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
