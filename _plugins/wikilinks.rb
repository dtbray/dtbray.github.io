# Jekyll Wikilinks Plugin
# =======================
# A lightweight plugin that adds [[wikilink]] support to Jekyll posts.
# Works with GitHub Pages (no external gems required).
#
# INSTALLATION:
# 1. Copy this file to: _plugins/wikilinks.rb
# 2. Commit the file to your repository
# 3. GitHub Pages will automatically use it when building your site
#
# USAGE:
# In your markdown posts, use any of these syntaxes:
#   [[Post Title]] → Links to post with that title, display text is the title
#   [[Post Title|Display Text]] → Links to post, with custom display text
#   [[filename.md]] → Links to post by filename
#
# EXAMPLE:
#   See also [[My First Post]] for more details.
#   Check out [[2023-01-01-my-post.md|this post]] for examples.
#
# MATCHING BEHAVIOR:
# - Titles are matched case-insensitively
# - If multiple posts match, the first match is used
# - If no match found, the text is left as-is (or shown as strikethrough if configured)
#
# THEME COMPATIBILITY:
# - Works with Jekyll Theme Chirpy and other standard Jekyll themes
# - Compatible with GitHub Pages' Jekyll build process

module Jekyll
  class WikilinksGenerator < Generator
    safe true
    priority :low

    def generate(site)
      # Build lookup tables for all posts
      @site = site
      @posts_by_title = {}
      @posts_by_filename = {}
      
      site.posts.docs.each do |post|
        # Index by title (case-insensitive)
        if post.data['title']
          @posts_by_title[post.data['title'].downcase] = post
        end
        
        # Index by filename (without date prefix)
        basename = File.basename(post.path)
        @posts_by_filename[basename.downcase] = post
        
        # Also index by slug (filename without extension and date)
        if basename =~ /\d{4}-\d{2}-\d{2}-(.+)\.\w+$/
          slug = $1.downcase
          @posts_by_filename[slug] = post
        end
      end
      
      # Also index pages if needed
      site.pages.each do |page|
        if page.data['title']
          @posts_by_title[page.data['title'].downcase] = page
        end
      end
      
      # Store lookup in site config for access by filters
      site.config['wikilinks_index'] = {
        'by_title' => @posts_by_title,
        'by_filename' => @posts_by_filename
      }
    end
  end

  module WikilinksFilter
    # Regex pattern for wikilinks
    # Matches: [[Title]] or [[Title|Display Text]]
    WIKILINK_REGEX = /\[\[([^\]|]+)(?:\|([^\]]+))?\]\]/
    
    # Configuration: Set to true to mark broken links with strikethrough
    def wikilink_config
      @context.registers[:site].config.fetch('wikilinks', {})
    end
    
    def wikilinkify(content)
      return content unless content.is_a?(String)
      
      site = @context.registers[:site]
      posts_by_title = {}
      posts_by_filename = {}
      
      # Build lookup from actual posts
      site.posts.docs.each do |post|
        if post.data['title']
          posts_by_title[post.data['title'].downcase] = post
        end
        
        basename = File.basename(post.path)
        posts_by_filename[basename.downcase] = post
        
        if basename =~ /\d{4}-\d{2}-\d{2}-(.+)\.\w+$/
          slug = $1.downcase
          posts_by_filename[slug] = post
        end
      end
      
      # Include pages in lookup
      site.pages.each do |page|
        if page.data['title']
          posts_by_title[page.data['title'].downcase] = page
        end
      end
      
      content.gsub(WIKILINK_REGEX) do |match|
        link_target = $1.strip
        display_text = $2 ? $2.strip : link_target
        
        # Try to find the post/page
        target = nil
        search_key = link_target.downcase
        
        # First try matching by title
        target = posts_by_title[search_key]
        
        # Then try matching by filename/slug
        target ||= posts_by_filename[search_key]
        target ||= posts_by_filename["#{search_key}.md"]
        target ||= posts_by_filename["#{search_key}.markdown"]
        
        if target
          # Found a match - create the link
          url = target.url
          "[#{display_text}](#{url})"
        else
          # No match found - handle broken link
          mark_broken = wikilink_config.fetch('mark_broken', false)
          
          if mark_broken
            "<span style='text-decoration: line-through; opacity: 0.6;'>#{display_text}</span>"
          else
            # Leave as plain text (remove brackets)
            display_text
          end
        end
      end
    end
  end

  # Alternative: Use a hook to preprocess content before rendering
  Hooks.register :posts, :pre_render do |post, payload|
    site = post.site
    
    # Build lookup
    posts_by_title = {}
    posts_by_filename = {}
    
    site.posts.docs.each do |p|
      if p.data['title']
        posts_by_title[p.data['title'].downcase] = p
      end
      
      basename = File.basename(p.path)
      posts_by_filename[basename.downcase] = p
      
      if basename =~ /\d{4}-\d{2}-\d{2}-(.+)\.\w+$/
        slug = $1.downcase
        posts_by_filename[slug] = p
      end
    end
    
    site.pages.each do |p|
      if p.data['title']
        posts_by_title[p.data['title'].downcase] = p
      end
    end
    
    # Process wikilinks in content
    if post.content
      post.content = post.content.gsub(/\[\[([^\]|]+)(?:\|([^\]]+))?\]\]/) do |match|
        link_target = $1.strip
        display_text = $2 ? $2.strip : link_target
        
        target = nil
        search_key = link_target.downcase
        
        target = posts_by_title[search_key]
        target ||= posts_by_filename[search_key]
        target ||= posts_by_filename["#{search_key}.md"]
        target ||= posts_by_filename["#{search_key}.markdown"]
        
        if target
          "[#{display_text}](#{target.url})"
        else
          mark_broken = site.config.fetch('wikilinks', {}).fetch('mark_broken', false)
          if mark_broken
            "<span style='text-decoration: line-through; opacity: 0.6;'>#{display_text}</span>"
          else
            display_text
          end
        end
      end
    end
  end
  
  # Also hook for pages
  Hooks.register :pages, :pre_render do |page, payload|
    site = page.site
    
    posts_by_title = {}
    posts_by_filename = {}
    
    site.posts.docs.each do |p|
      if p.data['title']
        posts_by_title[p.data['title'].downcase] = p
      end
      
      basename = File.basename(p.path)
      posts_by_filename[basename.downcase] = p
      
      if basename =~ /\d{4}-\d{2}-\d{2}-(.+)\.\w+$/
        slug = $1.downcase
        posts_by_filename[slug] = p
      end
    end
    
    site.pages.each do |p|
      if p.data['title']
        posts_by_title[p.data['title'].downcase] = p
      end
    end
    
    if page.content
      page.content = page.content.gsub(/\[\[([^\]|]+)(?:\|([^\]]+))?\]\]/) do |match|
        link_target = $1.strip
        display_text = $2 ? $2.strip : link_target
        
        target = nil
        search_key = link_target.downcase
        
        target = posts_by_title[search_key]
        target ||= posts_by_filename[search_key]
        target ||= posts_by_filename["#{search_key}.md"]
        target ||= posts_by_filename["#{search_key}.markdown"]
        
        if target
          "[#{display_text}](#{target.url})"
        else
          mark_broken = site.config.fetch('wikilinks', {}).fetch('mark_broken', false)
          if mark_broken
            "<span style='text-decoration: line-through; opacity: 0.6;'>#{display_text}</span>"
          else
            display_text
          end
        end
      end
    end
  end

  # Register the filter for use in templates
  Liquid::Template.register_filter(WikilinksFilter)
end
