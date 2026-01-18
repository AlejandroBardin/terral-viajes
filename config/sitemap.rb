# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = ENV.fetch("APP_HOST", "https://terralviajes.com")
SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/"

SitemapGenerator::Sitemap.create do
  # Homepage
  add "/", priority: 1.0, changefreq: "daily"

  # Individual packages
  Package.find_each do |package|
    add "/packages/#{package.id}", priority: 0.8, changefreq: "weekly", lastmod: package.updated_at
  end

  # Add other static pages here as needed
  # add '/about', priority: 0.7, changefreq: 'monthly'
  # add '/contact', priority: 0.7, changefreq: 'monthly'
end
