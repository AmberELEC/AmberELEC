# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="textviewer"
PKG_VERSION="fee8c65e83d39a03c245bb205c577345d63b47d7"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/lethal-guitar/TvTextViewer"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_SHORTDESC="Full-screen text viewer tool with gamepad controls"
PKG_TOOLCHAIN="make"
GET_HANDLER_SUPPORT="git"

pre_patch() {
  find $(echo "${PKG_BUILD}" | cut -f1 -d\ ) -type f -exec dos2unix -q {} \;
}

pre_configure_target() {
  sed -i "s|sdl2-config|$SYSROOT_PREFIX/usr/bin/sdl2-config|g" Makefile
  sed -i 's|ImGui::SetNextWindowFocus();|ImGui::SetFocusID(ImGui::GetID("Close"), ImGui::GetCurrentWindow());\n    ImGui::GetCurrentContext()->NavDisableHighlight = false;\n    ImGui::GetCurrentContext()->NavDisableMouseHover = true;|g' view.cpp
  sed -i 's|ImGui::PushStyleColor(ImGuiCol_WindowBg, ImVec4(ImColor(94, 11, 22, 255))); // Set window background to red|ImGui::PushStyleColor(ImGuiCol_Button, ImVec4(ImColor(100, 0, 0, 255)));\n    ImGui::PushStyleColor(ImGuiCol_NavHighlight, ImVec4(ImColor(180, 0, 0, 255)));\n    ImGui::PushStyleColor(ImGuiCol_ButtonHovered, ImVec4(ImColor(180, 0, 0, 255)));|g' main.cpp
  sed -i 's|ImColor(94, 11, 22,|ImColor(180, 0, 0,|g' main.cpp
  sed -i 's|BUTTON_START|BUTTON_INVALID|g' main.cpp
}

makeinstall_target(){
  mkdir -p $INSTALL/usr/bin
  cp text_viewer $INSTALL/usr/bin
}
