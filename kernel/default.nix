{ stdenv
, buildPackages
, fetchFromGitLab
, perl
, buildLinux
, modDirVersionArg ? null
, ... } @ args:

let
  inherit (stdenv.lib)
    concatStrings
    intersperse
    take
    splitString
    optionalString
  ;
in
(
  buildLinux (args // rec {
    version = "5.7";

    # modDirVersion needs to be x.y.z, will automatically add .0 if needed
    modDirVersion = if (modDirVersionArg == null) then concatStrings (intersperse "." (take 3 (splitString "." "${version}.0"))) else modDirVersionArg;

    # branchVersion needs to be x.y
    extraMeta.branch = concatStrings (intersperse "." (take 2 (splitString "." version)));

    # Manjaro package: https://gitlab.manjaro.org/manjaro-arm/packages/core/linux-pinebookpro
    # Kernel source: https://gitlab.manjaro.org/tsys/linux-pinebook-pro
    src = fetchFromGitLab {
      domain = "gitlab.manjaro.org";
      owner = "tsys";
      repo = "linux-pinebook-pro";
      rev = "a8f4db8a726e5e4552e61333dcd9ea1ff35f39f9";
      sha256 = "1vbach0y28c29hjjx4sc9hda4jxyqfhv4wlip3ky93vf4gxm2fij";
    };

    postInstall = (optionalString (args ? postInstall) args.postInstall) + ''
      mkdir -p "$out/nix-support"
      cp -v "$buildRoot/.config" "$out/nix-support/build.config"
    '';
  } // (args.argsOverride or {}))
)
#).overrideAttrs(args: {
#  postInstall = (optionalString (args ? postInstall) args.postInstall) + ''
#    mkdir -p "$out/nix-support"
#    cp -v "$buildRoot/.config" "$out/nix-support/build.config"
#  '';
#})
