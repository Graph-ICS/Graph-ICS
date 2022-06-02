
#include "serversocket.hpp"

#include <boost/asio.hpp>
#include <boost/thread/thread.hpp>
#include <iostream>
#include <string>

int main(int argc, char* argv[])
{
    boost::asio::io_context ioContext;

    boost::thread ioThread([&] {
        // instantiate server inside thread
        ServerSocket server(ioContext, 1234);
        ioContext.run();
    });

    std::cout << "Server started...\n" << std::endl;
    std::string exit = "";
    while (exit != "exit" || exit != "e" || exit != "q" || exit != "quit")
    {
        std::cout << "Type \"exit\", \"e\", \"quit\" or \"q\" to exit the application\n";
        std::cin >> exit;
        if (exit == "exit" || exit == "e" || exit == "q" || exit == "quit")
        {
            break;
        }
    }

    ioContext.stop();

    std::cout << "Server exited\n";
    return 0;
}
