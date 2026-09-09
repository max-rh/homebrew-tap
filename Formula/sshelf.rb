class Sshelf < Formula
  desc "Fast terminal UI for your SSH hosts: fuzzy-search and connect, transfer files over SFTP, and run background port forwards. Keeps its own host database and never edits ~/.ssh/config."
  homepage "https://max-rh.github.io/sshelf"
  version "0.14.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/max-rh/sshelf/releases/download/v0.14.0/sshelf-aarch64-apple-darwin.tar.xz"
      sha256 "e8d20dcd821a18915d3d46deb7c304c631e6169f0cddb176e43eede7910618ae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-rh/sshelf/releases/download/v0.14.0/sshelf-x86_64-apple-darwin.tar.xz"
      sha256 "2a9fa86aca4a7ba29591c221928c000bd739ec9972c2e175de53c3778353661a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/max-rh/sshelf/releases/download/v0.14.0/sshelf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dc6a4686253735e1be1e9d1dad11f1f5a8480aed13c8cbc1bb339d19ec2deb27"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-rh/sshelf/releases/download/v0.14.0/sshelf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c2e79af40cb0bb446573269a0c895b3d8078f9906c525a03a9b8f128be3d0867"
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
