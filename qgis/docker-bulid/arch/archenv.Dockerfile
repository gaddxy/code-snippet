# 使用 Arch Linux 官方镜像作为基础镜像
FROM archlinux:latest


# 更新系统并安装必要的工具和依赖
RUN pacman -Syu --noconfirm \
    && pacman -S --noconfirm \
    ocl-icd proj geos gdal expat spatialindex qwt libzip sqlite3 protobuf \
         zlib exiv2 postgresql-libs libspatialite zstd pdal \
         qt5-base qt5-svg qt5-serialport qt5-location qt5-3d qt5-declarative qt5-multimedia \
         qscintilla-qt5 qtkeychain-qt5 qca-qt5 gsl python-pyqt5 python-qscintilla-qt5 \
         hdf5 netcdf libxml2 draco \
         cmake ninja opencl-clhpp fcgi qt5-tools sip pyqt-builder base-devel git

# 创建普通用户
ARG user=makepkg
RUN useradd --system --create-home $user \
  && echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user
USER $user
WORKDIR /home/$user

# Install yay
RUN git clone https://aur.archlinux.org/yay.git \
  && cd yay \
  && makepkg -sri --needed --noconfirm \
  && cd \
  # Clean up
  && rm -rf .cache yay

RUN yay -Syu qt5-webkit --noconfirm
USER root
