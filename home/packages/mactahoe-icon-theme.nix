{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  hicolor-icon-theme,
  jdupes,

  boldPanelIcons ? false,
  themeVariants ? [ ],
}:
let
  pname = "mactahoe-icon-theme";
in
lib.checkListOfEnum "${pname}: theme variants" [
  "default" "blue" "purple" "red" "orange" "yellow" "green" "grey" "nord" "all"
] themeVariants

stdenvNoCC.mkDerivation {
  inherit pname;
  version = "unstable-2025-10-16";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "MacTahoe-icon-theme";
    rev = "b85923bb87f50578268abcff5698947a3ff24695";
    hash = "sha256-Ho71thvHpgQICfC0c67ClKRONdDeNVfg0bGU6ZjM3S8=";
  };

  nativeBuildInputs = [
    gtk3
    jdupes
  ];

  buildInputs = [ hicolor-icon-theme ];

  dontPatchELF = true;
  dontRewriteSymlinks = true;
  dontDropIconThemeCache = true;

  postPatch = ''
    patchShebangs install.sh
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    ./install.sh \
      --dest $out/share/icons \
      --name MacTahoe \
      --theme ${if themeVariants == [ ] then "default" else toString themeVariants} \
      ${lib.optionalString boldPanelIcons "--bold"}

    jdupes --link-soft --recurse $out/share

    runHook postInstall
  '';

  postFixup = ''
    find $out/share/icons -xtype l -delete
  '';

  meta = {
    description = "macOS Tahoe-like icon theme";
    homepage = "https://github.com/vinceliuice/MacTahoe-icon-theme";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}