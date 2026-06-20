class Sshelf < Formula
  desc "A TUI for managing and connecting to SSH hosts — generates the ssh command, never touches ~/.ssh/config."
  homepage "https://github.com/max-rh/sshelf"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/max-rh/sshelf/releases/download/v0.6.0/sshelf-aarch64-apple-darwin.tar.xz"
      sha256 "7df16a15822d2b975971d70090eb8ea0ef3f7507f4cd1810f2e761f46fbfed91"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-rh/sshelf/releases/download/v0.6.0/sshelf-x86_64-apple-darwin.tar.xz"
      sha256 "7a29bc1b3df5e856d3969aca1ae2cf9c22aac9dfc773246d4cc946d150e583ee"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/max-rh/sshelf/releases/download/v0.6.0/sshelf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c45677e69bd5e1b325646cc89b33ece179f8a651d0ef9228550024d3499d0f49"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-rh/sshelf/releases/download/v0.6.0/sshelf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "472910fe402258283f4f265f1bb2eab6c01178ab94db42c2013ea4a200e7b889"
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
