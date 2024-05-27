{
  description = "My React Native project";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; # 24.05
    flake-utils.url = "github:numtide/flake-utils";
    # android-nixpkgs.url = "github:tadfisher/android-nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils }: # android-nixpkgs
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            android_sdk.accept_license = true;
            allowUnfree = true;
          };
        };

        javaJDK = pkgs.jdk17;
        buildToolsVersion = "34.0.0";
        ndkVersion = "26.3.11579264";

        androidComposition = pkgs.androidenv.composeAndroidPackages {
          cmdLineToolsVersion = "8.0";
          toolsVersion = "26.1.1";
          platformToolsVersion = "34.0.4";
          buildToolsVersions = [ buildToolsVersion ];
          includeEmulator = true;
          emulatorVersion = "35.1.4";
          platformVersions = [ "34" ];
          includeSources = false;
          includeSystemImages = true;
          systemImageTypes = [ "google_apis_playstore" ];
          abiVersions = [ "x86_64" ];
          cmakeVersions = [ "3.10.2" "3.22.1" ];
          includeNDK = true;
          ndkVersions = [ ndkVersion ];
          useGoogleAPIs = true;
          useGoogleTVAddOns = false;
          includeExtras = [
            "extras;google;gcm"
          ];
        };
        androidSdk = androidComposition.androidsdk;
      in
      {
        devShell = pkgs.mkShell rec {

          buildInputs = with pkgs;
            [
              javaJDK
              androidSdk
              pkg-config
              yarn
              watchman
              android-studio
            ];

          JAVA_HOME = javaJDK;
          ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
          ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
          ANDROID_NDK_ROOT = "${ANDROID_SDK_ROOT}/ndk-bundle";

          # Workaround gradle dynamic link for aapt2
          GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${ANDROID_SDK_ROOT}/build-tools/${buildToolsVersion}/aapt2";
        };
      });
}
