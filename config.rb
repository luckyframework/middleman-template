require "lib/table_of_contents_helper"
require "lib/nav_active_helper"

helpers TableOfContentsHelper
helpers NavActiveHelper

activate :aria_current
activate :autoprefixer
activate :directory_indexes

set :css_dir, "assets/stylesheets"
set :fonts_dir, "assets/fonts"
set :images_dir, "assets/images"
set :js_dir, "assets/javascripts"
set :markdown,
  autolink: true,
  fenced_code_blocks: true,
  footnotes: true,
  highlight: true,
  smartypants: true,
  strikethrough: true,
  tables: true,
  with_toc_data: true
set :markdown_engine, :redcarpet

page "/*.json", layout: false
page "/*.txt", layout: false
page "/*.xml", layout: false
page "/guides/*", layout: "guide"

configure :development do
  activate :livereload do |reload|
    reload.no_swf = true
  end
end

configure :production do
  activate :gzip
  activate :minify_css
  activate :minify_html
  activate :minify_javascript
end

helpers do
  def guides_pages
    sitemap.resources.find_all do |resource|
      path = resource.path
      path.start_with?("guides/") && !path.start_with?("guides/index")
    end.sort_by do |page|
      page.data.order
    end
  end

  def next_guide_page
    guides_pages.find do |page|
      page.data.order > current_page.data.order
    end
  end
end
