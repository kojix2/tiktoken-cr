require "compress/zip"
require "digest/sha256"
require "file_utils"
require "http/client"
require "uri"

module TiktokenInstaller
  extend self

  VERSION      = "0.9.1"
  TAG          = "v#{VERSION}"
  REPOSITORY   = "https://github.com/kojix2/tiktoken-c"
  ROOT         = Path[__DIR__, ".."].expand
  INSTALL_DIR  = ROOT / "vendor" / "tiktoken-c"
  VERSION_FILE = ".tiktoken-c-version"

  record Asset, name : String, sha256 : String

  {% if flag?(:linux) && flag?(:x86_64) && !flag?(:musl) %}
    ASSET = Asset.new(
      "tiktoken-c-v0.9.1-linux-x86_64.tar.gz",
      "0b2c5c462602a7e95703e93a6d84222b20172e2d36ff7ece555fd2ff776f9a26"
    )
    STATIC_LIBRARY = "libtiktoken_c.a"
  {% elsif flag?(:darwin) && flag?(:aarch64) %}
    ASSET = Asset.new(
      "tiktoken-c-v0.9.1-macos-aarch64.tar.gz",
      "95b740f55bb63fe49b20dd0305aa9f1046645cc2b5d3c32a82b42aabf8b3fb77"
    )
    STATIC_LIBRARY = "libtiktoken_c.a"
  {% elsif flag?(:win32) && flag?(:x86_64) && !flag?(:gnu) %}
    ASSET = Asset.new(
      "tiktoken-c-v0.9.1-windows-x86_64.zip",
      "c4ee3ae6fad481b31fb19f5f080164858fa373fe0d656d62291a0228609bc16c"
    )
    STATIC_LIBRARY = "tiktoken_c.lib"
  {% else %}
    {% raise "tiktoken-cr does not provide a native library for this target" %}
  {% end %}

  def run
    if installed?
      puts "tiktoken: tiktoken-c #{VERSION} is already installed"
      return
    end

    archive = Path[File.tempname("tiktoken-c-#{VERSION}", File.extname(ASSET.name))]
    stage = ROOT / "vendor" / ".tiktoken-c-#{Process.pid}"

    begin
      url = "#{REPOSITORY}/releases/download/#{TAG}/#{ASSET.name}"
      puts "tiktoken: downloading #{url}"
      download(url, archive)
      verify(archive)
      extract(archive, stage)
      File.write(stage / VERSION_FILE, VERSION + "\n")
      FileUtils.rm_rf(INSTALL_DIR)
      FileUtils.mv(stage, INSTALL_DIR)
      puts "tiktoken: installed tiktoken-c #{VERSION}"
    ensure
      File.delete(archive) if File.exists?(archive)
      FileUtils.rm_rf(stage) if Dir.exists?(stage)
    end
  end

  private def installed? : Bool
    File.file?(INSTALL_DIR / STATIC_LIBRARY) &&
      File.file?(INSTALL_DIR / VERSION_FILE) &&
      File.read(INSTALL_DIR / VERSION_FILE).strip == VERSION
  end

  private def download(url : String, destination : Path)
    current = URI.parse(url)
    headers = HTTP::Headers{"User-Agent" => "tiktoken-cr/#{VERSION}"}

    6.times do
      response = HTTP::Client.get(current, headers)
      if response.status.success?
        File.write(destination, response.body.to_slice)
        return
      end

      if response.status.redirection? && (location = response.headers["Location"]?)
        current = current.resolve(location)
        next
      end

      raise "Download failed with HTTP #{response.status_code}: #{current}"
    end

    raise "Too many redirects while downloading #{url}"
  end

  private def verify(archive : Path)
    actual = Digest::SHA256.hexdigest(File.read(archive).to_slice)
    return if actual == ASSET.sha256

    raise "Checksum mismatch for #{ASSET.name}: expected #{ASSET.sha256}, got #{actual}"
  end

  private def extract(archive : Path, stage : Path)
    Dir.mkdir_p(stage.parent)
    FileUtils.rm_rf(stage)
    Dir.mkdir(stage)

    if ASSET.name.ends_with?(".zip")
      Compress::Zip::Reader.open(archive) do |zip|
        zip.each_entry do |entry|
          name = entry.filename.gsub("\\", "/").lchop("./")
          next unless {STATIC_LIBRARY, "LICENSE.txt"}.includes?(name)

          File.open(stage / name, "w") { |output| IO.copy(entry.io, output) }
        end
      end
    else
      run!("tar", ["-xzf", archive.to_s, "-C", stage.to_s, "./#{STATIC_LIBRARY}", "./LICENSE.txt"])
    end

    required = [STATIC_LIBRARY, "LICENSE.txt"]
    missing = required.reject { |name| File.file?(stage / name) }
    raise "Native package is missing: #{missing.join(", ")}" unless missing.empty?
  end

  private def run!(command : String, args : Array(String))
    status = Process.run(command, args, output: Process::Redirect::Inherit, error: Process::Redirect::Inherit)
    raise "#{command} failed with exit status #{status.exit_code}" unless status.success?
  end
end

begin
  TiktokenInstaller.run
rescue ex
  STDERR.puts "tiktoken: installation failed: #{ex.message}"
  exit 1
end
