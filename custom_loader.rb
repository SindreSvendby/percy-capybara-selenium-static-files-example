require 'percy/capybara/loaders/base_loader'
require 'digest'
require 'find'

class CustomLoader < ::Percy::Capybara::Loaders::BaseLoader
  SKIP_RESOURCE_EXTENSIONS = [
    '.map',  # Ignore source maps.
    '.gz',  # Ignore gzipped files.
  ]
  MAX_FILESIZE_BYTES = 15 * 1024**2  # 15 MB.

  def snapshot_resources
    [root_html_resource]
  end

  def build_resources
    resources = []

    # This should point to a _compilde_ static assets directory, not source assets.
    public_path = './dist'

    Find.find(public_path).each do |path|
      # Skip directories.
      next if !FileTest.file?(path)
      # Skip certain extensions.
      next if SKIP_RESOURCE_EXTENSIONS.include?(File.extname(path))
      # Skip large files, these are hopefully downloads and not used in page rendering.
      next if File.size(path) > MAX_FILESIZE_BYTES

      # Strip the public_path from the beginning of the resource_url.
      # This assumes that everything in the public_path directory is served at the root
      # of the app.
      resource_url = path.sub(public_path, '')

      sha = Digest::SHA256.hexdigest(File.read(path))
      resources << Percy::Client::Resource.new(resource_url, sha: sha, path: path)
    end
    resources
  end
end
