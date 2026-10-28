class Sshelf < Formula
  desc "Fast terminal UI for your SSH hosts: fuzzy-search and connect, transfer files over SFTP, and run background port forwards. Keeps its own host database and never edits ~/.ssh/config."
  homepage "https://max-rh.github.io/sshelf"
  version "0.16.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/max-rh/sshelf/releases/download/v0.16.3/sshelf-aarch64-apple-darwin.tar.xz"
      sha256 "4dce28672347a978fd95216dce4ca7f1e72a6aaa81ab3cc4b9eb9ad8dfe45caa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-rh/sshelf/releases/download/v0.16.3/sshelf-x86_64-apple-darwin.tar.xz"
      sha256 "3036c40e218025a23ea649f5e2587856252fbe37daa3b26ad256988bdce17932"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/max-rh/sshelf/releases/download/v0.16.3/sshelf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d14d4553b200293ef160f5e0fffa841ccadb003e2d91bb346ac05a0fff2f8712"
    end
    if Hardware::CPU.intel?
      url "https://github.com/max-rh/sshelf/releases/download/v0.16.3/sshelf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3d6b38225cd7afc2e99fb658b07fd0fb19e7103a6ca7f9d7023ad2bcacc9aa74"
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
