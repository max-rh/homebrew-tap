class Sshelf < Formula
  desc "Fast terminal UI for your SSH hosts: fuzzy-search and connect, transfer files over SFTP, and run background port forwards. Keeps its own host database and never edits ~/.ssh/config."
  homepage "https://max-rh.github.io/sshelf"
  version "0.16.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/max-rh/sshelf/releases/download/v0.16.0/sshelf-aarch64-apple-darwin.tar.xz"
      sha256 "132f98c214fdb34cc614dcbb8c2eec92545aa063b364bd85b42319fc38c462ff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-rh/sshelf/releases/download/v0.16.0/sshelf-x86_64-apple-darwin.tar.xz"
      sha256 "f66c646f5f2461629686eb1f28e62e435a580995d5385f3a6a8b2668f7af4d6d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/max-rh/sshelf/releases/download/v0.16.0/sshelf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2d2ab28d4daf30d3f4b933377859de07f8a27e9c116cb264102662a17fcb1ea0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-rh/sshelf/releases/download/v0.16.0/sshelf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d43f36c7359bab99185479c2ac0acff020282be81f69ec9a92b6ab6ffdc03aa9"
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
