class Sshelf < Formula
  desc "A TUI for managing and connecting to SSH hosts — generates the ssh command, never touches ~/.ssh/config."
  homepage "https://github.com/max-rh/sshelf"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/max-rh/sshelf/releases/download/v0.4.0/sshelf-aarch64-apple-darwin.tar.xz"
      sha256 "14d7fb859e0cde802cff23457af2449a82a0cfcc351ffecd9b32cb55b3e6471f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-rh/sshelf/releases/download/v0.4.0/sshelf-x86_64-apple-darwin.tar.xz"
      sha256 "cb59f282ecea85f82e89e3bc7ba05c7ee437ab8d05056b1ed7add2ef99ad6fe6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/max-rh/sshelf/releases/download/v0.4.0/sshelf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dcc7d8ddfc23fd6532f2f805a6ffb2e95b82d2a73371b762fbca6dd436970dff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-rh/sshelf/releases/download/v0.4.0/sshelf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fe20658fd08598b4327572783ea584613259be24fbc6af77b54c7beb8505c3d3"
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
