```bash
#!/usr/bin/env bash
set -euo pipefail

FFMPEG_VERSION="9.0.1"
FFMPEG_ARCHIVE="ffmpeg-${FFMPEG_VERSION}.tar.xz"
FFMPEG_URL="https://ffmpeg.org/releases/${FFMPEG_ARCHIVE}"
FFMPEG_DIR="ffmpeg-${FFMPEG_VERSION}"

echo "========================================"
echo " FFmpeg ${FFMPEG_VERSION} configure test"
echo "========================================"

echo
echo ">>> 检查 MSYS2 环境..."

if [[ "${MSYSTEM:-}" != "UCRT64" ]]; then
    echo "❌ 当前不是 MSYS2 UCRT64"
    echo "   MSYSTEM=${MSYSTEM:-未设置}"
    exit 1
fi

echo "✅ MSYSTEM=UCRT64"

echo
echo ">>> 检查基础工具..."

for cmd in wget tar gcc g++ make pkg-config nproc nasm; do
    if ! command -v "${cmd}" >/dev/null 2>&1; then
        echo "❌ 缺少工具: ${cmd}"
        exit 1
    fi
done

echo "✅ 基础工具齐全"

echo
echo ">>> 检查静态外部库..."

missing=0

for lib in \
    libmp3lame.a \
    libopus.a \
    libvorbis.a \
    libvorbisenc.a \
    libogg.a
do
    if [[ ! -f "/ucrt64/lib/${lib}" ]]; then
        echo "❌ 缺失: /ucrt64/lib/${lib}"
        missing=1
    else
        echo "✅ ${lib}"
    fi
done

if [[ "${missing}" -ne 0 ]]; then
    echo
    echo "❌ 静态外部库不完整"
    exit 1
fi

echo "✅ 静态外部库齐全"

echo
echo ">>> 检查 pkg-config..."

for pc in lame opus vorbis vorbisenc ogg; do
    if pkg-config --exists "${pc}"; then
        echo "✅ ${pc}.pc"
    else
        echo "❌ 缺少 pkg-config 模块: ${pc}"
        exit 1
    fi
done

echo "✅ pkg-config 检查通过"

echo
echo ">>> 检查 FFmpeg ${FFMPEG_VERSION} 源码..."

if [[ ! -d "${FFMPEG_DIR}" ]]; then
    echo ">>> 下载 ${FFMPEG_ARCHIVE}..."
    wget -q --show-progress "${FFMPEG_URL}"

    echo ">>> 解压 ${FFMPEG_ARCHIVE}..."
    tar -xf "${FFMPEG_ARCHIVE}"
else
    echo "✅ 源码目录已存在: ${FFMPEG_DIR}"
fi

cd "${FFMPEG_DIR}"

echo
echo ">>> 当前源码目录:"
pwd

echo
echo "========================================"
echo ">>> 开始 FFmpeg configure"
echo ">>> 本轮只配置，不执行 make"
echo "========================================"
echo

CONFIG_OUTPUT="configure-output.txt"

./configure \
    --target-os=mingw32 \
    --arch=x86_64 \
    \
    --enable-gpl \
    \
    --disable-shared \
    --enable-static \
    --pkg-config-flags="--static" \
    --extra-ldexeflags="-static" \
    \
    --disable-network \
    --disable-ffprobe \
    --disable-ffplay \
    \
    --disable-doc \
    --disable-debug \
    \
    --disable-avdevice \
    --disable-swscale \
    --disable-hwaccels \
    \
    --disable-everything \
    \
    --enable-avcodec \
    --enable-avformat \
    --enable-avfilter \
    --enable-swresample \
    --enable-avutil \
    \
    --enable-libmp3lame \
    --enable-libopus \
    --enable-libvorbis \
    \
    --enable-protocol=file \
    \
    --enable-demuxer=mov \
    --enable-demuxer=mp3 \
    --enable-demuxer=flac \
    --enable-demuxer=wav \
    --enable-demuxer=ogg \
    --enable-demuxer=aac \
    --enable-demuxer=image2 \
    \
    --enable-muxer=ipod \
    --enable-muxer=mp3 \
    --enable-muxer=flac \
    --enable-muxer=wav \
    --enable-muxer=ogg \
    --enable-muxer=adts \
    --enable-muxer=image2 \
    \
    --enable-decoder=aac \
    --enable-decoder=mp3 \
    --enable-decoder=flac \
    --enable-decoder=opus \
    --enable-decoder=vorbis \
    \
    --enable-decoder=pcm_s16le \
    --enable-decoder=pcm_s24le \
    --enable-decoder=pcm_s32le \
    --enable-decoder=pcm_f32le \
    --enable-decoder=pcm_f64le \
    \
    --enable-decoder=mjpeg \
    --enable-decoder=png \
    \
    --enable-encoder=aac \
    --enable-encoder=libmp3lame \
    --enable-encoder=libopus \
    --enable-encoder=libvorbis \
    --enable-encoder=flac \
    \
    --enable-encoder=pcm_s16le \
    --enable-encoder=pcm_s24le \
    --enable-encoder=pcm_s32le \
    --enable-encoder=pcm_f32le \
    --enable-encoder=pcm_f64le \
    \
    --enable-encoder=mjpeg \
    --enable-encoder=png \
    \
    --enable-parser=aac \
    --enable-parser=flac \
    --enable-parser=mpegaudio \
    --enable-parser=opus \
    --enable-parser=vorbis \
    \
    --enable-filter=aresample \
    --enable-filter=aformat \
    --enable-filter=anull \
    --enable-filter=atrim \
    --enable-filter=asetpts \
    --enable-filter=adelay \
    --enable-filter=atempo \
    --enable-filter=volume \
    --enable-filter=pan \
    --enable-filter=amerge \
    --enable-filter=amix \
    --enable-filter=channelmap \
    --enable-filter=channelsplit \
    --enable-filter=join \
    --enable-filter=apad \
    --enable-filter=afade \
    --enable-filter=acrossfade \
    --enable-filter=silenceremove \
    --enable-filter=equalizer \
    --enable-filter=bass \
    --enable-filter=treble \
    2>&1 | tee "${CONFIG_OUTPUT}"

echo
echo "========================================"
echo "✅ configure 成功"
echo "========================================"

echo
echo ">>> FFmpeg configure 摘要"
echo

sed -n '/^External libraries:/,$p' "${CONFIG_OUTPUT}"

echo
echo "========================================"
echo ">>> 输出文件"
echo "========================================"
echo "完整 configure 输出:"
echo "  ${CONFIG_OUTPUT}"
echo
echo "完整检测日志:"
echo "  ffbuild/config.log"
echo
echo "本轮没有执行 make。"
