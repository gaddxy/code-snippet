#!/bin/bash

CC="/usr/lib/ccache/gcc"
CXX="/usr/lib/ccache/g++"
LANG="C.UTF-8"
CCACHE_DIR="/QGIS/dxybuild-arch/.ccache_image_build"
PYTHONPATH="/usr/share/qgis/python/:/usr/share/qgis/python/plugins:/usr/lib/python3/dist-packages/qgis:/usr/share/qgis/python/qgis"

# 进入工作目录
cd /QGIS

git config --global --add safe.directory /QGIS

# 创建 ccache 缓存目录
mkdir -p $CCACHE_DIR
export CCACHE_DIR

# 初始化 ccache 设置
# ccache -M 1G
ccache -s
echo "ccache_dir: $(du -h --max-depth=0 $CCACHE_DIR)"

# 设置构建目录
mkdir -p /QGIS/dxybuild-arch
cd /QGIS/dxybuild-arch

# 运行 CMake 和 Ninja 构建 QGIS
SUCCESS=OK
cmake -GNinja \
  -DUSE_CCACHE=OFF \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DWITH_DESKTOP=ON \
  -DWITH_SERVER=ON \
  -DWITH_3D=ON \
  -DWITH_BINDINGS=ON \
  -DWITH_CUSTOM_WIDGETS=ON \
  -DBINDINGS_GLOBAL_INSTALL=ON \
  -DWITH_STAGED_PLUGINS=ON \
  -DWITH_GRASS=ON \
  -DSUPPRESS_QT_WARNINGS=ON \
  -DDISABLE_DEPRECATED=ON \
  -DENABLE_TESTS=OFF \
  -DWITH_QSPATIALITE=ON \
  -DWITH_APIDOC=OFF \
  -DWITH_ASTYLE=OFF \
  -DDEFAULT_FORCE_STATIC_LIBS=TRUE \
  ..
ninja install || SUCCESS=FAILED

# 输出构建结果
echo "$SUCCESS" > /QGIS/dxybuild-arch/build_exit_value
