class Sshelf < Formula
  desc "A TUI for managing and connecting to SSH hosts — generates the ssh command, never touches ~/.ssh/config."
  homepage "https://github.com/max-rh/sshelf"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/max-rh/sshelf/releases/download/v0.1.0/sshelf-aarch64-apple-darwin.tar.xz"
      sha256 "f91b6dbbac1af685c48f7fb6cdfbb06b93a2aae3e8ef32a8f7fa737b5233e9f0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-rh/sshelf/releases/download/v0.1.0/sshelf-x86_64-apple-darwin.tar.xz"
      sha256 "84b666276f1a46f8172ed04d1cc83721706869252667fbac94dcc2da826e64b4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/max-rh/sshelf/releases/download/v0.1.0/sshelf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0dffc5954e39b580d0a497908acf7ef44a9d52b09cafc544148a3d512f9d4cf8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-rh/sshelf/releases/download/v0.1.0/sshelf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a340907bd7b77148bcf03db179df4d1d0b8d9e32ce46c1afdb18dd926e1a5717"
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
