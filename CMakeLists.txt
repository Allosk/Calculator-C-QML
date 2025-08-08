cmake_minimum_required(VERSION 3.14)

project(calcu VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(QT_QML_GENERATE_QMLLS_INI ON)

find_package(Qt5 COMPONENTS Core Gui Widgets Quick REQUIRED)

qt5_add_resources(QML_RESOURCES src/qml/qml.qrc)

add_executable(calcu
    src/cpp/main.cpp 
    src/cpp/calculated.cpp

    ${QML_RESOURCES}
)



target_link_libraries(calcu Qt5::Core Qt5::Gui Qt5::Widgets Qt5::Quick)

