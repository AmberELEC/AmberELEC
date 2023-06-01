# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="textviewer"
PKG_VERSION="6820fd6e036e33f3d56b036978e6ec3c870c6b28"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/lethal-guitar/TvTextViewer"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Full-screen text viewer tool with gamepad controls"
PKG_TOOLCHAIN="make"

pre_patch() {
  find $(echo "${PKG_BUILD}" | cut -f1 -d\ ) -type f -exec dos2unix -q {} \;
}

pre_configure_target() {
  sed -i "s|#include <cstdlib>|#include <cstdlib>\n#include <cstdint>|g" main.cpp
  sed -i "s|sdl2-config|${SYSROOT_PREFIX}/usr/bin/sdl2-config|g" Makefile
  sed -i 's|ImGui::SetNextWindowFocus();|ImGui::SetFocusID(ImGui::GetID("Close"), ImGui::GetCurrentWindow());\n    ImGui::GetCurrentContext()->NavDisableHighlight = false;\n    ImGui::GetCurrentContext()->NavDisableMouseHover = true;|g' view.cpp
  sed -i 's|ImGui::PushStyleColor(ImGuiCol_WindowBg, ImVec4(ImColor(94, 11, 22, 255))); // Set window background to red|ImGui::PushStyleColor(ImGuiCol_Button, ImVec4(ImColor(100, 0, 0, 255)));\n    ImGui::PushStyleColor(ImGuiCol_NavHighlight, ImVec4(ImColor(180, 0, 0, 255)));\n    ImGui::PushStyleColor(ImGuiCol_ButtonHovered, ImVec4(ImColor(180, 0, 0, 255)));|g' main.cpp
  sed -i 's|ImColor(94, 11, 22,|ImColor(180, 0, 0,|g' main.cpp
  sed -i 's|BUTTON_START|BUTTON_INVALID|g' main.cpp

  if [[ "${DEVICE}" == "RG351P" ]]; then
    sed -i 's|    ImGui::GetIO().Fonts->AddFontDefault(&config);|    ImGui::GetIO().Fonts->AddFontDefault(\&config);\n  }\n  else\n  {\n    ImFontConfig config;\n    config.SizePixels = 13;\n    ImGui::GetIO().Fonts->AddFontDefault(\&config);|g' main.cpp
  elif [[ "${DEVICE}" == "RG552" ]]; then
    sed -i 's|    ImGui::GetIO().Fonts->AddFontDefault(&config);|    ImGui::GetIO().Fonts->AddFontDefault(\&config);\n  }\n  else\n  {\n    ImFontConfig config;\n    config.SizePixels = 48;\n    ImGui::GetIO().Fonts->AddFontDefault(\&config);|g' main.cpp
  else
    sed -i 's|    ImGui::GetIO().Fonts->AddFontDefault(&config);|    ImGui::GetIO().Fonts->AddFontDefault(\&config);\n  }\n  else\n  {\n    ImFontConfig config;\n    config.SizePixels = 20;\n    ImGui::GetIO().Fonts->AddFontDefault(\&config);|g' main.cpp
  fi
}

makeinstall_target(){
  mkdir -p ${INSTALL}/usr/bin
  cp text_viewer ${INSTALL}/usr/bin
}
