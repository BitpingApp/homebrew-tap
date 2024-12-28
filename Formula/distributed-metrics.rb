class DistributedMetrics < Formula
  desc "A monitoring tool backed by Bitping's distributed network, exposed as a Prometheus metrics endpoint"
  homepage "https://bitping.com"
  version "1.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/BitpingApp/distributed-metrics/releases/download/1.0.1/distributed-metrics-aarch64-apple-darwin.tar.xz"
      sha256 "f909c04d937183e6a6631613c2345b64759fb9179c41f5b2f7273fbaa76e58d7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BitpingApp/distributed-metrics/releases/download/1.0.1/distributed-metrics-x86_64-apple-darwin.tar.xz"
      sha256 "a62f42454d5d49dc0ffd128a80bb6d42534d68621c2429045e501f2898e16630"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/BitpingApp/distributed-metrics/releases/download/1.0.1/distributed-metrics-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "24bf2b210f3f64ef45b00888e7b8570d0eb8ac991e97735f3103a99d295ff302"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BitpingApp/distributed-metrics/releases/download/1.0.1/distributed-metrics-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4158bb90c515071547d999a658776d4f4951f6eb9debba3c7c8e982dd5114894"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "distributed-metrics" if OS.mac? && Hardware::CPU.arm?
    bin.install "distributed-metrics" if OS.mac? && Hardware::CPU.intel?
    bin.install "distributed-metrics" if OS.linux? && Hardware::CPU.arm?
    bin.install "distributed-metrics" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
