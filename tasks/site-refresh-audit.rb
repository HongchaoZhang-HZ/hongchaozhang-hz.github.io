#!/usr/bin/env ruby

require "digest"
require "open3"
require "optparse"
require "pathname"
require "set"
require "uri"
require "yaml"

ROOT = Pathname.new(__dir__).parent.expand_path

DELETED_PATHS = %w[
  _data/coauthors.yml
  _data/cv.yml
  _data/repositories.yml
  _data/venues.yml
  _includes/cv/list.html
  _includes/cv/list_groups.html
  _includes/cv/map.html
  _includes/cv/nested_list.html
  _includes/cv/time_table.html
  _includes/latest_posts.html
  _includes/news.html
  _includes/pagination.html
  _includes/repository/repo.html
  _includes/repository/repo_trophies.html
  _includes/repository/repo_user.html
  _includes/resume/awards.html
  _includes/resume/basics.html
  _includes/resume/certificates.html
  _includes/resume/education.html
  _includes/resume/interests.html
  _includes/resume/languages.html
  _includes/resume/projects.html
  _includes/resume/publications.html
  _includes/resume/references.html
  _includes/resume/skills.html
  _includes/resume/volunteer.html
  _includes/resume/work.html
  _layouts/archive-category.html
  _layouts/archive-tag.html
  _layouts/archive-year.html
  _layouts/cv.html
  _layouts/post.html
  _news/CDC2024a.md
  _news/CDC2024b.md
  _news/ICAA2024.md
  _news/NeurIPS2024.md
  _pages/dropdown.md
  _pages/repositories.md
  _plugins/external-posts.rb
  _projects/MI_Arithmetic.md
  _projects/MI_ConceptProbing.md
  _projects/MI_Grokking.md
  _projects/MI_LLMInternals.md
  _projects/MI_RepEReading.md
  _projects/MI_VanillaSteering.md
  assets/audio/epicaly-short-113909.mp3
  assets/img/al-folio-preview.png
  assets/img/code-screenshot.png
  assets/img/distill-screenshot.png
  assets/img/math-screenshot.png
  assets/img/photos-screenshot.png
  assets/img/projects-screenshot.png
  assets/img/publications-screenshot.png
  assets/img/publication_preview/FTNCBF_comp.gif
  assets/img/publication_preview/ICRA2020.gif
  assets/img/publication_preview/ag_biology.png
  assets/img/publication_preview/ag_methods.png
  assets/img/publication_preview/brownian-motion.gif
  assets/img/publication_preview/mi_acceleration_heatmap.png
  assets/img/publication_preview/mi_arithmetic_thumb.png
  assets/img/publication_preview/mi_dim_fourier.png
  assets/img/publication_preview/mi_grokking_curves.png
  assets/img/publication_preview/mi_llm_acc_vs_dft.png
  assets/img/publication_preview/mi_llm_dft_bars.png
  assets/img/publication_preview/mi_repe_problemsolve.png
  assets/img/publication_preview/mi_steer_thumb.png
  assets/img/publication_preview/wave-mechanics.gif
  assets/json/resume.json
  assets/json/table_data.json
  assets/jupyter/blog.ipynb
  assets/pdf/example_pdf.pdf
  assets/plotly/demo.html
  assets/video/pexels-engin-akyurt-6069112-960x540-30fps.mp4
  blog/index.html
  news.html
].freeze

REQUIRED_MEDIA_TARGETS = %w[
  assets/img/research-overview.png
  assets/img/publication_preview/FTNCBF_Demo.gif
  assets/img/publication_preview/ICRA2021.gif
  assets/img/publication_preview/IEEECDC2024.gif
  assets/img/publication_preview/TAC25FTSCBF.gif
  assets/img/publication_preview/TAC25SNCBF.gif
  assets/img/publication_preview/daecbf_3link.gif
  assets/img/publication_preview/daecbf_manipulator.gif
  assets/img/publication_preview/FTNCBF_Demo-static.png
  assets/img/publication_preview/ICRA2021-static.png
  assets/img/publication_preview/IEEECDC2024-static.png
  assets/img/publication_preview/TAC25FTSCBF-static.png
  assets/img/publication_preview/TAC25SNCBF-static.png
  assets/img/publication_preview/daecbf_3link-static.png
  assets/img/publication_preview/daecbf_manipulator-static.png
  assets/img/publication_preview/IEEECDC2020.png
  assets/img/publication_preview/IEEECDC2021.jpg
  assets/img/publication_preview/IEEECDC2022.png
  assets/img/publication_preview/IEEECDC2023.png
  assets/img/publication_preview/VehicleSec23Thumbnail.png
  assets/img/publication_preview/cdc24compatible.jpg
  assets/img/publication_preview/daecbf_manifold.png
  assets/img/publication_preview/ft_estimation.png
  assets/img/publication_preview/icaa2024.png
  assets/img/publication_preview/nashvillewater.png
  assets/img/publication_preview/seev_training.jpg
  assets/img/publication_preview/zhang2023exact.png
  assets/img/publication_preview/zhang2024seev_poster.jpg
].freeze

SOURCE_GLOBS = %w[
  _config.yml
  404.html
  Gemfile
  _pages/**/*
  _projects/**/*
  _layouts/**/*
  _includes/**/*
  _bibliography/**/*
  assets/css/**/*
  assets/js/**/*
].freeze

LINK_SOURCE_GLOBS = %w[
  _config.yml
  _pages/**/*
  _projects/**/*
  _bibliography/**/*
].freeze

def source_files
  SOURCE_GLOBS.flat_map { |pattern| Dir.glob(ROOT.join(pattern)) }
              .select { |path| File.file?(path) }
              .uniq
end

def active_source_text
  source_files.map { |path| File.binread(path).force_encoding("UTF-8").scrub }.join("\n")
end

def fail_with(messages)
  messages.each { |message| warn(message) }
  exit 1
end

def deleted_reference_tokens(relative)
  stem = File.basename(relative, File.extname(relative))
  case relative
  when %r{\A_includes/}
    [relative.delete_prefix("_includes/")]
  when %r{\A_layouts/}
    ["layout: #{stem}", "layout: /#{stem}"]
  when %r{\A_data/}
    ["site.data.#{stem}"]
  when %r{\A_(?:news|projects)/}
    [stem]
  when "_pages/dropdown.md"
    ["/dropdown/"]
  when "_pages/repositories.md"
    ["/repositories/"]
  when "_plugins/external-posts.rb"
    ["external_sources", "external-posts.rb"]
  when "blog/index.html"
    ["/blog/"]
  when "news.html"
    ["/news/"]
  when %r{\Aassets/}
    [relative]
  else
    []
  end
end

def check_deletions
  errors = DELETED_PATHS.each_with_object([]) do |relative, result|
    result << "obsolete path still exists: #{relative}" if ROOT.join(relative).exist?
  end

  forbidden = {
    "/blog/" => "obsolete blog route is still referenced",
    "/news/" => "obsolete news route is still referenced",
    "/repositories/" => "obsolete repositories route is still referenced",
    "jekyll-get-json" => "obsolete jekyll-get-json dependency remains",
    "jsonresume" => "obsolete jsonresume configuration remains",
    "jekyll_get_json" => "obsolete jekyll_get_json configuration remains",
    "jekyll-minifier" => "unstable jekyll-minifier dependency remains",
    "mini_racer" => "unstable mini_racer dependency remains"
  }
  text = active_source_text
  forbidden.each do |token, message|
    errors << message if text.include?(token)
  end

  stdout, stderr, status = Open3.capture3("git", "-C", ROOT.to_s, "diff", "--diff-filter=D", "--name-only", "HEAD")
  errors << "unable to enumerate tracked deletions: #{stderr.strip}" unless status.success?
  live_deleted = stdout.lines.map(&:strip).reject(&:empty?)
  missing_receipts = live_deleted - DELETED_PATHS
  stale_receipts = DELETED_PATHS - live_deleted
  errors << "missing deletion receipts: #{missing_receipts.join(', ')}" unless missing_receipts.empty?
  errors << "stale deletion receipts: #{stale_receipts.join(', ')}" unless stale_receipts.empty?
  errors << "expected 75 tracked deletion receipts, found #{DELETED_PATHS.length}" unless DELETED_PATHS.length == 75

  reference_checks = 0
  DELETED_PATHS.each do |relative|
    deleted_reference_tokens(relative).each do |token|
      reference_checks += 1
      errors << "deleted path still referenced (#{relative}): #{token}" if text.include?(token)
    end
  end

  fail_with(errors) unless errors.empty?
  puts "deletion audit: PASS (#{DELETED_PATHS.length} deletion receipts; #{reference_checks} zero-reference checks)"
end

def parse_bib_entries
  text = File.read(ROOT.join("_bibliography/papers.bib"))
  entries = []
  text.scan(/@([A-Za-z]+)\s*\{\s*([^,]+),(.+?)\n\}/m) do |type, key, body|
    fields = {}
    body.scan(/^\s*([A-Za-z_]+)\s*=\s*[\{\"](.*?)[\}\"]\s*,?\s*$/) do |name, value|
      fields[name.downcase] = value.strip
    end
    entries << { type: type.downcase, key: key.strip, fields: fields }
  end
  entries
end

def normalized_title(title)
  title.to_s.downcase.gsub(/[{}\\]/, "").gsub(/[^a-z0-9]+/, " ").strip
end

def check_bibliography
  entries = parse_bib_entries
  errors = []
  errors << "expected 32 bibliography records, found #{entries.length}" unless entries.length == 32

  duplicate_keys = entries.group_by { |entry| entry[:key].downcase }.select { |_key, values| values.length > 1 }.keys
  errors << "duplicate bibliography keys: #{duplicate_keys.join(', ')}" unless duplicate_keys.empty?

  duplicate_titles = entries.group_by { |entry| normalized_title(entry[:fields]["title"]) }
                            .select { |title, values| !title.empty? && values.length > 1 }.keys
  errors << "duplicate bibliography titles: #{duplicate_titles.join(' | ')}" unless duplicate_titles.empty?

  groups = entries.group_by { |entry| entry[:fields]["status_group"] }.transform_values(&:length)
  errors << "expected 24 published records, found #{groups['published'] || 0}" unless groups["published"] == 24
  errors << "expected 8 preprint records, found #{groups['preprint'] || 0}" unless groups["preprint"] == 8

  required = %w[
    zhang2026dae zhang2027semiimplicit zhang2027error liu2027vocabulary
    wooding2027inputagnostic he2027formal woodingSafeFlight atiq2027robustness
  ]
  keys = entries.map { |entry| entry[:key].downcase }
  required.each do |key|
    errors << "missing required bibliography key: #{key}" unless keys.count(key.downcase) == 1
  end


  seev = entries.find { |entry| entry[:key].casecmp("NEURIPS2024_b7868ded").zero? }
  if seev
    errors << "P09 DOI mismatch" unless seev[:fields]["doi"] == "10.52202/079017-3214"
    errors << "P09 equal-contribution note mismatch" unless seev[:fields]["note"] == "H. Zhang and Z. Qin contributed equally"
  else
    errors << "missing P09 NEURIPS2024_b7868ded"
  end

  award = entries.find { |entry| entry[:key].casecmp("zhang2023cooperative").zero? }
  errors << "General Motors award note contains literal Markdown asterisks" if award && award[:fields]["note"].include?("*")

  publications_page = File.read(ROOT.join("_pages/publications.md"))
  errors << "publication page disables year grouping" if publications_page.include?("group_by none")
  errors << "publication page does not use the configured year-grouped bibliography" unless publications_page.include?("{% bibliography -f {{ site.scholar.bibliography }} %}")

  bib_layout = File.read(ROOT.join("_layouts/bib.html"))
  errors << "under-review title label is missing" unless bib_layout.include?('(Under review)') && bib_layout.include?('entry.status_group == "preprint"')

  fail_with(errors) unless errors.empty?
  puts "bibliography audit: PASS (32 records; 24 published, 8 preprint)"
end

def check_media
  ledger_path = ROOT.join("tasks/site-refresh-media.yml")
  fail_with(["missing media ledger: tasks/site-refresh-media.yml"]) unless ledger_path.file?

  entries = YAML.safe_load(File.read(ledger_path), [], [], false).fetch("media")
  errors = []
  targets = entries.map { |entry| entry.fetch("target") }
  errors << "expected 28 media records, found #{entries.length}" unless entries.length == 28
  errors << "duplicate media targets: #{targets.group_by(&:itself).select { |_target, values| values.length > 1 }.keys.join(', ')}" unless targets.uniq.length == targets.length
  missing_targets = REQUIRED_MEDIA_TARGETS - targets
  unexpected_targets = targets - REQUIRED_MEDIA_TARGETS
  errors << "missing media ledger targets: #{missing_targets.join(', ')}" unless missing_targets.empty?
  errors << "unexpected media ledger targets: #{unexpected_targets.join(', ')}" unless unexpected_targets.empty?
  entries.each do |entry|
    target = ROOT.join(entry.fetch("target"))
    unless target.file?
      errors << "missing media target: #{entry['target']}"
      next
    end
    actual = Digest::SHA256.file(target).hexdigest
    errors << "media hash mismatch: #{entry['target']}" unless actual == entry.fetch("sha256")
    errors << "missing logical media source: #{entry['target']}" if entry.fetch("source").start_with?("/")
    errors << "missing media alt text: #{entry['target']}" if entry.fetch("alt").strip.empty?
  end

  fail_with(errors) unless errors.empty?
  puts "media provenance audit: PASS (#{entries.length} records)"
end


def check_accessibility(site_root)
  errors = []
  bib_layout = File.read(ROOT.join("_layouts/bib.html"))
  about_layout = File.read(ROOT.join("_layouts/about.html"))
  about_page = File.read(ROOT.join("_pages/about.md"))

  errors << "more-authors control is not a native button" unless bib_layout.include?("<button") && bib_layout.include?('type="button"')
  errors << "more-authors control lacks aria-expanded state updates" unless bib_layout.include?('aria-expanded="false"') && bib_layout.include?("attr('aria-expanded'")
  errors << "more-authors span remains" if bib_layout.match?(/<span[^>]*class=["']more-authors/)
  errors << "deleted venues data branch remains" if bib_layout.include?("site.data.venues")
  errors << "deleted coauthors data branch remains" if bib_layout.include?("site.data.coauthors")
  errors << "about profile lacks meaningful alt front matter" unless about_page.match?(/^\s+alt:\s+Portrait of Hongchao Zhang\s*$/)
  errors << "about layout does not use profile alt with a meaningful fallback" unless about_layout.include?("profile_alt") && about_layout.include?("Portrait of Hongchao Zhang")

  publications_path = site_root.join("publications/index.html")
  home_path = site_root.join("index.html")
  if publications_path.file?
    publications = File.read(publications_path)
    buttons = publications.scan(/<button\b[^>]*class=["']more-authors["'][^>]*>/m)
    errors << "expected 26 native more-authors buttons, found #{buttons.length}" unless buttons.length == 26
    buttons.each_with_index do |button, index|
      errors << "more-authors button #{index + 1} lacks type=button" unless button.include?('type="button"')
      errors << "more-authors button #{index + 1} lacks collapsed aria state" unless button.include?('aria-expanded="false"')
      errors << "more-authors button #{index + 1} lacks an accessible name" unless button.include?('aria-label="Show ')
    end
    errors << "rendered more-authors span remains" if publications.match?(/<span[^>]*class=["']more-authors/)
    errors << "rendered award note contains literal Markdown asterisks" if publications.include?("**General Motors AutoDriving Security Award**")
    errors << "expected eight inline Under review labels" unless publications.scan(/\(Under review\)/).length == 8
    errors << "legacy publication status sections remain" if publications.include?("Published and Accepted") || publications.include?("Preprints and Under Review")
    %w[2027 2026 2025 2024 2023 2022 2021 2020].each do |year|
      errors << "missing publication year divider: #{year}" unless publications.match?(/<h2[^>]*class=["']bibliography["'][^>]*>\s*#{year}\s*<\/h2>/m)
    end
  else
    errors << "missing generated publications page"
  end

  if home_path.file?
    home = File.read(home_path)
    errors << "rendered home portrait alt is not meaningful" unless home.include?('alt="Portrait of Hongchao Zhang"')
  else
    errors << "missing generated home page"
  end

  fail_with(errors) unless errors.empty?
  puts "accessibility repair audit: PASS (26 native buttons; Enter/Space semantics provided by HTML button)"
end

def check_orphans
  text = active_source_text
  errors = Dir.glob(ROOT.join("assets/img/publication_preview/*")).each_with_object([]) do |path, result|
    name = File.basename(path)
    result << "unreferenced publication preview: assets/img/publication_preview/#{name}" unless text.include?(name)
  end
  fail_with(errors) unless errors.empty?
  puts "publication-preview orphan audit: PASS"
end

def external_links
  text = LINK_SOURCE_GLOBS.flat_map { |pattern| Dir.glob(ROOT.join(pattern)) }
                          .select { |path| File.file?(path) }
                          .uniq
                          .map { |path| File.binread(path).force_encoding("UTF-8").scrub }
                          .join("\n")
  text.scan(%r{https?://[^\s<>{}\]\[\)\"]+}).map { |url| url.sub(/[.,;:]\z/, "") }.uniq.sort
end

def check_html(site_root)
  errors = []
  html_files = Dir.glob(site_root.join("**/*.html"))
  html_files.each do |path|
    text = File.read(path)
    ids = text.scan(/\sid=["']([^"']+)["']/).flatten
    duplicates = ids.group_by(&:itself).select { |_id, values| values.length > 1 }.keys
    errors << "duplicate HTML id in #{Pathname.new(path).relative_path_from(ROOT)}: #{duplicates.join(', ')}" unless duplicates.empty?

    text.scan(/(?:href|src)=["']([^"']+)["']/).flatten.each do |reference|
      next if reference.empty? || reference.start_with?("#", "mailto:", "tel:", "javascript:", "data:", "http://", "https://", "//")
      path_part = reference.split("#", 2).first.split("?", 2).first
      next if path_part.empty?
      candidate = if path_part.start_with?("/")
                    site_root.join(path_part.delete_prefix("/"))
                  else
                    Pathname.new(path).dirname.join(path_part).cleanpath
                  end
      candidates = [candidate, candidate.join("index.html")]
      errors << "broken generated link in #{Pathname.new(path).relative_path_from(ROOT)}: #{reference}" unless candidates.any?(&:exist?)
    end
  end
  fail_with(errors.uniq) unless errors.empty?
  puts "generated HTML audit: PASS (#{html_files.length} files)"
end

options = { site: ROOT.join("_site") }
parser = OptionParser.new do |opts|
  opts.on("--check-deletions") { options[:deletions] = true }
  opts.on("--check-bibliography") { options[:bibliography] = true }
  opts.on("--check-media") { options[:media] = true }
  opts.on("--check-orphans") { options[:orphans] = true }
  opts.on("--check-accessibility") { options[:accessibility] = true }
  opts.on("--list-external-links") { options[:links] = true }
  opts.on("--site PATH") { |path| options[:site] = ROOT.join(path) }
  opts.on("--check-html") { options[:html] = true }
end
parser.parse!

selected = options.values_at(:deletions, :bibliography, :media, :orphans, :accessibility, :links, :html).any?
abort(parser.to_s) unless selected

check_deletions if options[:deletions]
check_bibliography if options[:bibliography]
check_media if options[:media]
check_orphans if options[:orphans]
check_accessibility(options[:site]) if options[:accessibility]
puts external_links if options[:links]
check_html(options[:site]) if options[:html]
