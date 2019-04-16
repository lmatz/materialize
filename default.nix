# Copyright 2019 Materialize, Inc. All rights reserved.
#
# This file is part of Materialize. Materialize may not be used or
# distributed without the express permission of Materialize, Inc.

let

pkgs = import (builtins.fetchTarball {
  name = "nixos-unstable";
  url = https://github.com/nixos/nixpkgs/archive/1fc591f9a5bd1b016b5d66dfab29560073955a14.tar.gz;
  sha256 = "1ij5x1qw486rbih7xh2c01s60c3zblj6ad1isf5y99sh47jcq76c";
}) {};

confluent = pkgs.callPackage ./confluent.nix { pkgs = pkgs; };

in pkgs.stdenv.mkDerivation rec {
  name = "materialize";
  buildInputs = with pkgs; [
    openssl
    pkgconfig
    rustup

    curl # for testing

    postgresql # only for psql
    less # for psql

    confluent
    ] ++
    (if stdenv.isDarwin then [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.CoreServices
    ] else []);
}