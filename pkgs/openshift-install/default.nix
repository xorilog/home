{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "openshift-install";
  version = "4.4.11";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${version}/openshift-install-linux-${version}.tar.gz";
    sha256 = "0sahh666xalz60ycf6cv771xkhmfz4kvj6gbj217mzbpgb4pzlbd";
  };

  phases = " unpackPhase installPhase fixupPhase ";

  unpackPhase = ''
    runHook preUnpack
    mkdir ${name}
    tar -C ${name} -xzf $src
  '';

  installPhase = ''
    runHook preInstall
    install -D ${name}/openshift-install $out/bin/openshift-install
    # completions
    mkdir -p $out/share/bash-completion/completions/
    $out/bin/openshift-install completion bash > $out/share/bash-completion/completions/openshift-install
    mkdir -p $out/share/zsh/site-functions
    $out/bin/openshift-install completion zsh > $out/share/zsh/site-functions/_openshift-install
  '';

  meta = {
    description = "Install an OpenShift cluster";
    homepage = https://github.com/openshift/installer;
    license = lib.licenses.asl20;
  };
}
