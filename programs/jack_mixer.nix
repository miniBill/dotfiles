{ cairo
, fetchFromGitHub
, lib
, pkg-config
, pkgs
, python3
, python3Packages
, wrapGAppsHook
}:

python3Packages.buildPythonApplication rec {
  pname = "jack_mixer";
  version = "17";

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "jack-mixer";
    repo = pname;
    rev = "release-${version}"; # "b71543b57d319b0a7d6c54d705ff6cc8e1c0b4e9";
    sha256 = "0q7l3zvmppbw53r9234ifmswq2fkrc4844g6j337l9jznxl1nbqh";
  };

  nativeBuildInputs = with pkgs; [
    gettext
    meson
    ninja
    pkg-config
    python3Packages.cython
    python3Packages.docutils
    # wrapGAppsHook
  ];

  # dontWrapGApps = true;
  # # Arguments to be passed to `makeWrapper`, only used by buildPython*
  # preFixup = ''
  #   makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  # '';

  buildInputs = with pkgs; [
    cairo
    glib
    gtk3
    libjack2
    python3
  ];

  propagatedBuildInputs = with python3Packages; [
    cython
    pycairo
    pygobject3
    xdg
  ];

  dontUsePipInstall = true;
  dontUseSetuptoolsBuild = true;
  dontUseSetuptoolsCheck = true;

  meta = with lib; {
    description = "A multi-channel audio mixer desktop application for the JACK Audio Connection Kit. ";
    homepage = https://github.com/jack-mixer/jack_mixer;
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" ];
  };
}
