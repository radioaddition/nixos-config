{
  inputs,
  pkgs,
  ...
}:{
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];
  nixpkgs.overlays = [
    inputs.nix-minecraft.overlay
  ];
  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true;
    declarative = true;
    package = pkgs.fabricServers.fabric-26_3.override {
      loaderVersion = "0.20.1";
    };
    serverProperties = {
      difficulty = 2;
      gamemode = 0;
      max-players = 5;
      motd = "RadioAddition's fabric modpack running on a NixOS server!";
    };
    symlinks = {
      mods = pkgs.linkFarmFromDrvs "mods" (
        builtins.attrValues {
          Fabric-API = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/EQKgpeKu/fabric-api-0.165.0+26.3.jar";
            sha256sum = "121cxxax2hv1wydyxwdib1kcmrlmhjv4rfvxqd0yzmk6shm2wi0q";
          };
          Maces-Origins = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/HAm8Lm3M/versions/ZnJcCB4V/maces-origins-updated-2-fabric-1.0.2+mc26.3.jar";
            sha256sum = "16mn9wcgqfa2nwhbgbarvx7772bkyzhzf22x6ics3d92m5vxhnyc";
          };
          FerriteCore = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/uXXizFIs/versions/d5ddUdiB/ferritecore-9.0.0-fabric.jar";
            sha256sum = "08mzwryxphh1g0p6r5xravzh38zvcsl2isrb773sqryr5v3ncf91";
          };
          Lithium = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/fWv5bnZk/lithium-fabric-0.26.3+mc26.3.jar";
            sha256sum = "0y7w8hhm8la8qbpabxwvdfi0vgmi6czll9b5alaikw9j76mnlfqh";
          };
          AppleSkin = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/EsAfCjCV/versions/PHjDtQay/appleskin-fabric-mc26.3-3.0.10.jar";
            sha256sum = "1kn3nmqc73f10g4sfy0knz8i80jncg7ygym139hn1n7h75y0h1fb";
          };
          JEI = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/u6dRKJwZ/versions/Zebwcvua/jei-26.3-fabric-31.14.0.72.jar";
            sha256sum = "1z2n12xna2bgvvlz8jg2w1vyg9byd31rqzjcpp91f1fp9mh25lkr";
          };
          VC = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/x9jLR94Q/voicechat-fabric-2.6.27+26.3.jar";
            sha256sum = "9e1c93144a3f7498e546102f6786aea6e4992866c4c5d21bd2e0edb702399153";
          };
          Jade = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/nvQzSEkH/versions/71CTWqdE/Jade-mc26.3-Fabric-26.3.5.jar";
            sha256sum = "4899d6c60afa2af859b3a7e0824d0ef6b404f26458f831e3d877faa36be9af1c";
          };
          NoReport = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/qQyHxfxd/versions/6g96avt2/NoChatReports-FABRIC-26.3-v2.21.0.jar?mr_download_reason=standalone&mr_loader=fabric";
            sha256sum = "1gxm6k46csg7hk7bw86jsqs6gz2b86531j5kbrfvm4brx8dkjink";
          };
          ViaFabric = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/YlKdE5VK/versions/z1FVDMnq/ViaFabric-0.4.22+188-26.x.jar";
            sha256sum = "1rc81cdbj91gnpk6jn5i3zz4xqnlw2k2lyavf8fr72wqk48njgcd";
          };
          ViaVersion = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/P1OZGk5p/versions/cVhZ1kgN/ViaVersion-5.12.2.jar";
            sha256sum = "1cp66020bw8g6gwi219v1m7xshl15c7q41iy8ks3hz8grfnkpdn0";
          };
          ViaBackwards = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/NpvuJQoq/versions/1xHfYAKG/ViaBackwards-5.12.2.jar";
            sha256sum = "1aw7ivlhrqjh0kn9aslnc1vbd4a6hpgmfyjxd3a14zmd187492g9";
          };
          Krypton = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/UugdIYJw/krypton-0.3.2.jar";
            sha256sum = "1vwznzc3ljdznqmhgh30gfrcbfmjb3zjlwa9z13q411gkj5n8jhb";
          };
          NetherPortalFix = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/nPZr02ET/versions/RC1fmH8z/netherportalfix-fabric-26.3-26.3.0.1.jar";
            sha256sum = "1xjzm35jij84ccbx8whkzx6rfl42wgd2zcanc8qfk73695xsawy8";
          };
          Clumps = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/Wnxd13zP/versions/J4I1wxJZ/Clumps-fabric-26.3-26.3.2.jar";
            sha256sum = "093nxlcnrwxyi2i8vm93ncpajv83dbmi9adm37nr7b8ib98b2wlc";
          };
          Debugify = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/QwxR6Gcd/versions/FMaS2nZn/debugify-26.3.0.0.jar";
            sha256sum = "0qwgh9m05qpq3h2nlvnyqyz9givw8r14vzl2hx1sc1vjk426ij48";
          };
          DistantHorizons = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/uCdwusMi/versions/TGgEbP9A/DistantHorizons-3.3.4-26.3-fabric-neoforge.jar";
            sha256sum = "0irripa3p68nc5wsdpxj0ppcvkzmkswrkprik0hhk8b5ly2mqgms";
          };
          PacketFixer = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/c7m1mi73/versions/dTKbGYbb/PacketFixer-fabric-3.3.6.jar";
            sha256sum = "1ghp3ysahmz186ql9wa45wqpl4c5vjck02lwc6i1w5c1x2fyz7ki";
          };
          Balm = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/MBAkmtvl/versions/HY6fKMHC/balm-fabric-1.21.1-21.0.67.jar";
            sha256sum = "0qbdkgjn9ibi8bppmc9cpfag3j5153fpbk02k2bdr117azgy3143";
          };
          Parties = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/gF3BGWvG/versions/KBCCg0os/open-parties-and-claims-fabric-26.3-0.33.0.jar";
            sha256sum = "1a6nd83j58mh0i9fl8l7b2vrn1lbickzpwcpcncadmwphcviz6l0";
          };
          Chunky = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/fALzjamp/versions/86FKD9qx/Chunky-Fabric-1.5.66.jar";
            sha256sum = "04hhapp26jx1hmnc1zpnb2630qmgr4dwakdp3lcy8fmypr3dwylq";
          };
          ServerCore = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/4WWQxlQP/versions/LCG1Bm84/servercore-fabric-1.5.20+26.3.jar";
            sha256sum = "0rchmaqpimnx8qxj2p6wcn4daga72ska7kzribv76nwiqz1agyv2";
          };
          XMap = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/stTaMuWa/versions/Nt0Yoefe/xmmp-1.2.4+26.2-fabric.jar";
            sha256sum = "0arv2wc7apzs5z3rfw1cyn007w8vkjzvbhj27bazszh8ksxll71k";
          };
          Camera = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/RlBTYKIp/versions/KWj6GEgT/camera-obscura-fabric-2.1.1+26.3.jar";
            sha256sum = "1a9q55yivhs5ksi9f9kvc3ai3ycqcxcyb3h9v4hq91l4zd8js941";
          };
          AutoModpack = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/k68glP2e/versions/s49Ma0rZ/automodpack-5.0.0-rc.7.jar";
            sha256sum = "05rp79d9nwn2gkjxsq475qyb5zzbv7z7n1znmy241cp5d2lnxr4n";
          };
        });
      };
  };
}
