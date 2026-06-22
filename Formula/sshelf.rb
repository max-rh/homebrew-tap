class Sshelf < Formula
  desc "A TUI for managing and connecting to SSH hosts — generates the ssh command, never touches ~/.ssh/config."
  homepage "https://github.com/max-rh/sshelf"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/max-rh/sshelf/releases/download/v0.7.0/sshelf-aarch64-apple-darwin.tar.xz"
      sha256 "ddb413583e8c9367f1e21b19c96edabd78b86f720809e35a184d9e90a9f6450c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-rh/sshelf/releases/download/v0.7.0/sshelf-x86_64-apple-darwin.tar.xz"
      sha256 "4cea89e97003b4dab1cb7d91d095e01f1e405254baa66dd60030b0c6f665c002"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/max-rh/sshelf/releases/download/v0.7.0/sshelf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4ae668e609bf5d01c6d444fb049fc44f83ac72933221caba28ebf3701db57747"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-rh/sshelf/releases/download/v0.7.0/sshelf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "671bf1f8a759d4eaa3d2c34e8be36412f5c50a8ef79a416b8a62570ec008e777"
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
