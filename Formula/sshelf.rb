class Sshelf < Formula
  desc "Fast terminal UI for your SSH hosts: fuzzy-search and connect, transfer files over SFTP, and run background port forwards. Keeps its own host database and never edits ~/.ssh/config."
  homepage "https://max-rh.github.io/sshelf"
  version "0.15.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/max-rh/sshelf/releases/download/v0.15.0/sshelf-aarch64-apple-darwin.tar.xz"
      sha256 "f664c1f664ee50d7698fc248ab8763e37835adfceea9dd8d6a321048d85c282a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-rh/sshelf/releases/download/v0.15.0/sshelf-x86_64-apple-darwin.tar.xz"
      sha256 "ea85a9b424aa961d0391b2301fb0b6055636145272c85a0b60b7bfdaad55dff9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/max-rh/sshelf/releases/download/v0.15.0/sshelf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "df3d5160a6048e025764132cabbf0a59fe7e978c70e53acbf63de5f6ea545882"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-rh/sshelf/releases/download/v0.15.0/sshelf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1d1a697235e24919b1d852cb02f6fec896a91cef1d6dda2f0f52c6b9af6f22e7"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "sshelf"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "sshelf"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "sshelf"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "sshelf"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
