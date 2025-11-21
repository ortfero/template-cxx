build_dir := "build"
debug_dir := build_dir + "/debug"
release_dir := build_dir + "/release"

default: debug

debug:
    conan install . -s build_type=Debug --build=missing --output-folder=build
    cmake --preset conan-debug
    cmake --build --preset conan-debug

release:
    conan install . -s build_type=RelWithDebInfo --build=missing --output-folder=build
    cmake --preset conan-relwithdebinfo
    cmake --build --preset conan-relwithdebinfo

test: debug
    cmake --build {{debug_dir}} --parallel
    cd {{debug_dir}} && ctest --output-on-failure

tidy:
    echo "formatting..."
    find src include test -type f \( -name '*.cpp' -o -name '*.hpp' \) \
        -exec clang-format -i {} +

    cmake -S . -B {{debug_dir}} -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

    echo "analyzing..."
    clang-tidy \
        $(find src include test -type f -name '*.cpp') \
        -p {{debug_dir}}

