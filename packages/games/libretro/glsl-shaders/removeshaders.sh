#! /bin/sh

# Fail to load

rm -f $1/usr/share/common-shaders/cel/presets/MMJ_Cel_Shader_3dfx.glslp
rm -f $1/usr/share/common-shaders/cel/presets/MMJ_Cel_shader_cmyk_halftone.glslp
rm -f $1/usr/share/common-shaders/cel/presets/MMJ_Cel_Shader_strong_extra.glslp
rm -f $1/usr/share/common-shaders/cel/presets/MMJ_Cel_Shader_variant.glslp
rm -f $1/usr/share/common-shaders/cel/presets/MMJ_Cel_Shader_vhs.glslp
rm -f $1/usr/share/common-shaders/cel/presets/MMJ_Cel_Shader_vhs_variant.glslp
rm -f $1/usr/share/common-shaders/cel/presets/MMJ_Cel_Shader_vhs_variant_bayer.glslp
rm -f $1/usr/share/common-shaders/cel/presets/MMJ_Cel_Shader_vhs_variant_deposterize.glslp
rm -f $1/usr/share/common-shaders/cel/presets/MMJ_Cel_Shader_vhs_variant_gendither.glslp
rm -f $1/usr/share/common-shaders/cel/presets/MMJ_Cel_Shader_vhs_variant_natural_colors.glslp
rm -f $1/usr/share/common-shaders/cel/presets/MMJ_Cel_Shader_vhs_variant_ntsc.glslp
rm -f $1/usr/share/common-shaders/cel/advcartoon.glslp
rm -f $1/usr/share/common-shaders/cel/MMJ_Cel_Shader_MP.glslp
rm -f $1/usr/share/common-shaders/crt/crt-caligari.glslp
rm -f $1/usr/share/common-shaders/crt/crt-royale-fake-bloom.glslp
rm -f $1/usr/share/common-shaders/crt/crt-royale-ntsc-256px-composite.glslp
rm -f $1/usr/share/common-shaders/crt/crt-royale-ntsc-256px-svideo.glslp
rm -f $1/usr/share/common-shaders/crt/crt-royale-ntsc-320px-composite.glslp
rm -f $1/usr/share/common-shaders/crt/crt-royale-ntsc-320px-svideo.glslp
rm -f $1/usr/share/common-shaders/crt/crt-royale-pal-r57shell.glslp
rm -f $1/usr/share/common-shaders/crt/crt-royale.glslp
rm -f $1/usr/share/common-shaders/crt/crt-torridgristle.glslp
rm -f $1/usr/share/common-shaders/crt/mame_hlsl.glslp
rm -f $1/usr/share/common-shaders/crt/tvout-tweaks-linearized-multipass.glslp
rm -f $1/usr/share/common-shaders/crt/yee64.glslp
rm -f $1/usr/share/common-shaders/crt/yeetron.glslp
rm -f $1/usr/share/common-shaders/cubic/cubic.glslp
rm -f $1/usr/share/common-shaders/deblur/simoneT-3d-2d-mixed.glslp
rm -f $1/usr/share/common-shaders/denoisers/crt-fast-bilateral-super-xbr.glslp
rm -f $1/usr/share/common-shaders/denoisers/fast-bilateral-super-2xbr-3d-3p.glslp
rm -f $1/usr/share/common-shaders/denoisers/fast-bilateral-super-xbr-natural-vision.glslp
rm -f $1/usr/share/common-shaders/dithering/bayer-matrix-dithering.glslp
rm -f $1/usr/share/common-shaders/gpu/powervr2.glslp
rm -f $1/usr/share/common-shaders/interpolation/controlled_sharpness.glslp
rm -f $1/usr/share/common-shaders/nes_raw_palette/cgwg-famicom-geom.glslp
rm -f $1/usr/share/common-shaders/nes_raw_palette/pal-r57shell-raw.glslp
rm -f $1/usr/share/common-shaders/ntsc/ntsc-320px-gauss-scanline.glslp
rm -f $1/usr/share/common-shaders/ntsc/ntsc-320px-*.glslp
rm -f $1/usr/share/common-shaders/ntsc/ntsc-adaptive.glslp
rm -f $1/usr/share/common-shaders/pal/pal-r57shell.glslp
rm -f $1/usr/share/common-shaders/pal/pal.glslp
rm -f $1/usr/share/common-shaders/presets/tvout/gtu-famicom-240p.glslp
rm -f $1/usr/share/common-shaders/presets/tvout/tvout+*.glslp
rm -f $1/usr/share/common-shaders/presets/tvout/tvout-jinc-sharpen.glslp
rm -f $1/usr/share/common-shaders/presets/tvout/tvout-pixelsharp.glslp
rm -f $1/usr/share/common-shaders/presets/tvout/tvout.glslp
rm -f $1/usr/share/common-shaders/presets/tvout+interlacing/gtu-famicom-240p+interlacing.glslp
rm -f $1/usr/share/common-shaders/presets/tvout+interlacing/tvout+*.glslp
rm -f $1/usr/share/common-shaders/presets/tvout+interlacing/tvout-jinc-sharpen+interlacing.glslp
rm -f $1/usr/share/common-shaders/presets/crt-guest-dr-venom-ntsc-*
rm -f $1/usr/share/common-shaders/presets/crt-hyllian-*.glslp
rm -f $1/usr/share/common-shaders/presets/crt-royale-*.glslp
rm -f $1/usr/share/common-shaders/presets/scalefx+rAA*.glslp
rm -f $1/usr/share/common-shaders/procedural/*.glslp
rm -f $1/usr/share/common-shaders/reshade/bloom.glslp
rm -f $1/usr/share/common-shaders/scalefx/scalefx+rAA.glslp
rm -f $1/usr/share/common-shaders/scale3x/scale3x.glslp
rm -f $1/usr/share/common-shaders/sharpen/adaptive-sharpen-multipass.glslp
rm -f $1/usr/share/common-shaders/sharpen/super-xbr-super-res.glslp
rm -f $1/usr/share/common-shaders/vhs/mudlord-pal-vhs.glslp
rm -f $1/usr/share/common-shaders/xbr/super-4xbr-*.glslp
rm -f $1/usr/share/common-shaders/xbr/super-8xbr-*.glslp
rm -f $1/usr/share/common-shaders/xbr/xbr-lvl2*.glslp

# Loads without display

rm -f $1/usr/share/common-shaders/crt/crt-easymode-halation.glslp
rm -f $1/usr/share/common-shaders/crt/crt-guest-dr-venom.glslp
rm -f $1/usr/share/common-shaders/crt/crtglow_gauss.glslp
rm -f $1/usr/share/common-shaders/crt/crtglow_gauss_ntsc_3phase.glslp
rm -f $1/usr/share/common-shaders/crt/crtglow_lanczos.glslp
rm -f $1/usr/share/common-shaders/presets/crt-guest-dr-venom-kurozumi.glslp
rm -f $1/usr/share/common-shaders/presets/xsoft+scalefx-level2aa+sharpsmoother.glslp
rm -f $1/usr/share/common-shaders/rpi/gameboy.glslp
rm -f $1/usr/share/common-shaders/rpi/gameboy2.glslp

# Nearly freezing

rm -f $1/usr/share/common-shaders/anti-aliasing/aa-shader-4.0-level2.glslp
rm -f $1/usr/share/common-shaders/anti-aliasing/aa-shader-4.0.glslp
rm -f $1/usr/share/common-shaders/crt/crt-lottes.glslp
rm -f $1/usr/share/common-shaders/crt/crt-mattias.glslp
rm -f $1/usr/share/common-shaders/crt/metacrt.glslp
rm -f $1/usr/share/common-shaders/denoisers/fast-bilateral-super-xbr-4p.glslp
rm -f $1/usr/share/common-shaders/denoisers/fast-bilateral-super-xbr-6p.glslp
rm -f $1/usr/share/common-shaders/nnedi3/*.glslp
rm -f $1/usr/share/common-shaders/ntsc/ntsc-xot.glslp
rm -f $1/usr/share/common-shaders/omniscale/*.glslp
rm -f $1/usr/share/common-shaders/presets/c64-monitor.glslp
rm -f $1/usr/share/common-shaders/sharpen/adaptive-sharpen.glslp
rm -f $1/usr/share/common-shaders/xbr/super-xbr-6p-*.glslp
rm -f $1/usr/share/common-shaders/xbrz/4x*.glslp
rm -f $1/usr/share/common-shaders/xbrz/5x*.glslp
rm -f $1/usr/share/common-shaders/xbrz/6x*.glslp

# Slightly rough

#rm -f $1/usr/share/common-shaders/crt/crt-yo6-KV-M1420B-sharp.glslp
#rm -f $1/usr/share/common-shaders/crt/crt-yo6-KV-M1420B.glslp
#rm -f $1/usr/share/common-shaders/deblur/sedi.glslp
#rm -f $1/usr/share/common-shaders/denoisers/fast-bilateral-super-xbr.glslp
#rm -f $1/usr/share/common-shaders/denoisers/slow-bilateral.glslp
#rm -f $1/usr/share/common-shaders/nedi/fast-bilateral-nedi.glslp
#rm -f $1/usr/share/common-shaders/nedi/nedi.glslp
#rm -f $1/usr/share/common-shaders/nes_raw_palette/gtu-famicom.glslp
#rm -f $1/usr/share/common-shaders/ntsc/artifact-colors.glslp
#rm -f $1/usr/share/common-shaders/presets/scalefx-aa.glslp
#rm -f $1/usr/share/common-shaders/presets/xsoft+scalefx+hybrid+level2aa.glslp
#rm -f $1/usr/share/common-shaders/presets/xsoft+scalefx-level2aa.glslp
#rm -f $1/usr/share/common-shaders/rpi/nedi.glslp
#rm -f $1/usr/share/common-shaders/xbr/xbr-hybrid.glslp

# Broken display

#rm -f $1/usr/share/common-shaders/film/technicolor.glslp
#rm -f $1/usr/share/common-shaders/handheld/ds-hybrid-sabr.glslp
#rm -f $1/usr/share/common-shaders/kurg/kurg-ROPi-scanlines-3x.glslp
#rm -f $1/usr/share/common-shaders/presets/crt-faker/crt-faker-glow-2.glslp
