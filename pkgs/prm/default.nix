{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "prm-${version}";
  version = "3.4.0";
  rev = "v${version}";

  buildFlagsArray = let t = "github.com/ldez/prm/v3/meta"; in
    ''
      -ldflags=
         -X ${t}.Version=${version}
         -X ${t}.BuildDate=unknown
    '';

  src = fetchFromGitHub {
    inherit rev;
    owner = "ldez";
    repo = "prm";
    sha256 = "1vpii7046rq13ahjkbk7rmbqskk6x1mcsrzqx91nii7nzl32wdap";
  };
  vendorHash = "sha256-/zE9po/d+uNG57IaLyu11jcCqAC90sMKIxPS2UkoP0I=";

  meta = {
    description = "Pull Request Manager for Maintainers";
    homepage = "https://github.com/ldez/prm";
    license = lib.licenses.asl20;
  };
}
