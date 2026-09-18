```bash
./configure \
    --prefix=/ucrt64 \
    \
    --enable-gpl \
    --enable-libmp3lame \
    --enable-libopus \
    --enable-libvorbis \
    \
    --disable-network \
    --disable-ffprobe \
    --disable-ffplay \
    \
    --disable-everything \
    \
    --enable-protocol=file \
    \
    --enable-demuxer=mov \
    --enable-demuxer=mp3 \
    --enable-demuxer=flac \
    --enable-demuxer=wav \
    --enable-demuxer=ogg \
    --enable-demuxer=aac \
    \
    --enable-muxer=ipod \
    --enable-muxer=mp3 \
    --enable-muxer=flac \
    --enable-muxer=wav \
    --enable-muxer=ogg \
    \
    --enable-decoder=aac \
    --enable-decoder=mp3 \
    --enable-decoder=flac \
    --enable-decoder=opus \
    --enable-decoder=vorbis \
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
    --enable-encoder=pcm_s16le \
    --enable-encoder=pcm_s24le \
    --enable-encoder=pcm_s32le \
    --enable-encoder=pcm_f32le \
    --enable-encoder=pcm_f64le \
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
    --enable-filter=treble
```
