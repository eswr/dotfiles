
## Usage

Install [Nix][nix] with Nix Flake support enabled, for example by using the [Determinate Systems installer][nix-installer].
You should be able to run the `nix flake` command in a shell.

Next, clone this repository. We'll use `~/code/dotfiles`.

```shell
$ git clone git@github.com:eswr/nix-ubuntu.git ~/code/dotfiles
```

The home-manager profile can then be built and activated:

```shell
$ nix run home-manager/master -- switch --flake ~/code/dotfiles#eswr
```

To update dependencies:

```shell
$ nix flake update ~/code/dotfiles
```

```shell
# code nix/flake.nix
# code nix/home-manager/home.nix
#nix run nixpkgs#home-manager -- switch --flake nix/#eswr
nix run home-manager/master -- switch --flake ~/code/dotfiles#eswr

home-manager switch --flake nix/#$USER
nix develop --extra-experimental-features "nix-command flakes"
```

### Fish

I like to set [fish][fish] as my default shell. On macOS this means:

1. Editing `/etc/shells` to include an entry for the home-manager-managed
   `fish` binary at `~/.nix-profile/bin/fish`.
2. Setting the default shell with `chsh -s ~/.nix-profile/bin/fish`.


### nix-darwin

As an alternative to using home-manager alone, the configuration supports using
it with [nix-darwin][nix-darwin].

The initial setup requires moving the Nix configuration file created by the
Determinate Systems installer out of the way, so that nix-darwin can manage it
for us.

```
sudo mv /etc/nix/nix.conf{,.before-nix-darwin}
nix --extra-experimental-features 'nix-command flakes' run nix-darwin -- switch --flake (pwd)
```

Subsequent rebuilds, after configuration changes, are simpler.

```
darwin-rebuild switch --flake (pwd)
```
