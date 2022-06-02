# Building the Graph-ICS Plugins

## Available Plugins

- [Remote Plugin](#remote-plugin)

## Remote Plugin

The Remote plugin enables Graph-ICS to be used in a server-client use-case. The examples folder in the repository contains a fully extensible example with a server implementation and a remote node to demonstrate the usage.

### How to build the Remote Plugin

#### Step-by-Step

- Installing Boost
- Installing Protobuf
- Tell Graph-ICS to build the Plugin
- Build the Project

#### Installing Boost

**Windows:**

- Download and install [Boost](https://www.boost.org/doc/libs/1_71_0/more/getting_started/windows.html).
- Open the commandline and cd to the Boost folder.
- Run bootstrap.bat and wait for the execution to finish.
- Run b2.exe
- Add the "boost"-Folder to your Path environment variable. (e.g. D:\Libraries\boost_1_71_0).

 **Linux:** (Ubuntu)

 ```sh
 sudo apt-get install libboost-all-dev
 ```

Check if the installed version of boost is 1.71!

We use Boost version 1.71 because the Ubuntu package ships the 1.71 version. If you want to use the Remote plugin on a different server environment then Ubuntu you can use other Boost version but make sure that the client and server systems have the same version installed. *Compatibility with other Boost versions is not guaranteed as it has not been tested!*

#### Installing Protobuf

**Windows**

- Download the [source code](https://github.com/protocolbuffers/protobuf/releases/latest).
- Choose the cpp version, for example: protobuf-cpp-3.17.3.zip

**Option A**

- Follow [this instruction](https://github.com/protocolbuffers/protobuf/tree/master/src#c-installation---windows) (did not work for me).

**Option B**

- Build from source by following [this guide](https://github.com/protocolbuffers/protobuf/blob/master/cmake/README.md).
- Be sure to use the 64Bit version of the native tools command prompt of VS and run it with admin rights
- If you reach the cmake configuration, which looks like this:

```sh
C:\Path\to\protobuf\cmake\build>mkdir release & cd release
C:\Path\to\protobuf\cmake\build\release>cmake -G "NMake Makefiles" ^
-DCMAKE_BUILD_TYPE=Release ^
-DCMAKE_INSTALL_PREFIX=../../../../install ^
../..
```

- Keep in mind that you can change the install directory by changing the variable -DCMAKE_INSTALL_PREFIX=../../../../install
- You may also want to add the paramter: -Dprotobuf_MSVC_STATIC_RUNTIME=OFF only then I was able to build Graph-ICS afterwards
- Add the "bin"-Folder to your Path environment variable. For example: D:\Programms\protobuf\bin

**Linux**

```sh
sudo apt-get install libprotobuf-dev protobuf-compiler
```

#### Tell Graph-ICS to build the plugin

You need to enable the CMake cache variable GRAPHICS_PLUGIN_REMOTE so that Graph-ICS knows to build the plugin.

#### Build the project

Rerun CMake and build the project.

## How to use the Remote plugin

Once the build has finished you can run Graph-ICS. Now you can find a dialog to establish connections in the File/Connections menu. If you have enabled and build the [Examples](../examples/README.md) you should find a new node called "RemoteSobel" in the searchpanel. Now you can start the ExampleServer, establish the connection (using ip 127.0.0.1 and port 1234 if you have started the server on your machine) and try out the RemoteSobel node. The RemoteSobel node sends the input image to the server, the server calculates the resulting image and sends it back to the client.
