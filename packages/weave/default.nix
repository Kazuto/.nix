{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
}:
buildGoModule rec {
  pname = "weave";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "Kazuto";
    repo = "Weave";
    rev = "v${version}";
    hash = "sha256-R5RelXTM+zM9+Dsg/Hb1Yb0j8Q9UaO6svxs7jTxOk+s=";
  };

  vendorHash = "sha256-g+yaVIx4jxpAQ/+WrGKxhVeliYx7nLQe/zsGpxV4Fn4=";

  nativeCheckInputs = [ git ];

  postInstall = ''
    mv $out/bin/Weave $out/bin/.weave-tmp
    mv $out/bin/.weave-tmp $out/bin/weave
  '';

  meta = with lib; {
    description = "Weave";
    homepage = "https://github.com/kazuto/weave";
    license = licenses.mit;
    maintainers = [];
  };
}
