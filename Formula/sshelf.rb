class Sshelf < Formula
  desc "Fast terminal UI for your SSH hosts: fuzzy-search and connect, transfer files over SFTP, and run background port forwards — keeps its own host database and never edits ~/.ssh/config."
  homepage "https://max-rh.github.io/sshelf"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/max-rh/sshelf/releases/download/v0.9.0/sshelf-aarch64-apple-darwin.tar.xz"
      sha256 "605cddccb992e5705de43416efef78ffc402d769374df36a9b3162734570de5c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-rh/sshelf/releases/download/v0.9.0/sshelf-x86_64-apple-darwin.tar.xz"
      sha256 "0cb8a50e78423f4a14eae6e231e7fd408ce0edb547996fa04bd4c0ee6563b687"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/max-rh/sshelf/releases/download/v0.9.0/sshelf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e524f81417b2326c1210a5bc107a031548b6728c2606c11d6669ff3d8d75dc84"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-rh/sshelf/releases/download/v0.9.0/sshelf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "59d1a1cb1d4d583cc169fa0e073a1db66677c17a18a606b8ff9b0da0b050d72d"
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
    bin.install "sshelf" if OS.mac? && Hardware::CPU.arm?
    bin.install "sshelf" if OS.mac? && Hardware::CPU.intel?
    bin.install "sshelf" if OS.linux? && Hardware::CPU.arm?
    bin.install "sshelf" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
