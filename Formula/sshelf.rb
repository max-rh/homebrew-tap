class Sshelf < Formula
  desc "A TUI for managing and connecting to SSH hosts — generates the ssh command, never touches ~/.ssh/config."
  homepage "https://github.com/max-rh/sshelf"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/max-rh/sshelf/releases/download/v0.5.0/sshelf-aarch64-apple-darwin.tar.xz"
      sha256 "a1d301ed6bb382dab2d9b2f71ca0f03f8da1919d8a81a1711f2e2706fcb4faaa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-rh/sshelf/releases/download/v0.5.0/sshelf-x86_64-apple-darwin.tar.xz"
      sha256 "4568a542798f6d5ba83700a3102e0acb23c048e9aedcf16da608210aa7b023c7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/max-rh/sshelf/releases/download/v0.5.0/sshelf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e55f372771614aff505173c9434ffe42a2e7a4409bc74b4aae40cee5c55450dd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-rh/sshelf/releases/download/v0.5.0/sshelf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4e722513cf0dc52a7e4debcfd8bba0a888152b9af8350d23c93595bee15de8c9"
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
