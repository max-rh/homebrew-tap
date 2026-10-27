class Sshelf < Formula
  desc "Fast terminal UI for your SSH hosts: fuzzy-search and connect, transfer files over SFTP, and run background port forwards. Keeps its own host database and never edits ~/.ssh/config."
  homepage "https://max-rh.github.io/sshelf"
  version "0.16.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/max-rh/sshelf/releases/download/v0.16.1/sshelf-aarch64-apple-darwin.tar.xz"
      sha256 "109cdf35eef42a11e804d912d8828a86638ea1f8bcd0e6144e09e8e44353903e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-rh/sshelf/releases/download/v0.16.1/sshelf-x86_64-apple-darwin.tar.xz"
      sha256 "d06abd97947e71d0a9a9c596cd123655d0e3ae59fca2b3433ec88d2e2062fb28"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/max-rh/sshelf/releases/download/v0.16.1/sshelf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d0ceff85d9d8b5001b732bf57e9cd2e208d5f3c7f2f51a56de06bc1dcd83884d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-rh/sshelf/releases/download/v0.16.1/sshelf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2ecefb4551a23c06b1b1dcf62959b15428a933ece43ca7b0d6951b2a34277b5f"
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
