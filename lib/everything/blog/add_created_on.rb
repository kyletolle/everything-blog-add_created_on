# encoding: UTF-8
# NOTE: This is a simplified version of the OO-ified PostsFinder class from # everything-blog.
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
Dotenv.load
require 'active_support/all'

require_relative 'post'

module Everything
  class Piece
    class Metadata
      def save_yaml
        File.write(file_path, @raw_yaml.to_yaml)
      end
    end
  end
end

module Everything
  class Blog
    class AddCreatedOn
      # Usage: From project directory, start irb and run with:
      #   require './lib/everything/blog/add_created_on';Everything::Blog::AddCreatedOn.new.convert_wordpress_post_date_gmt_to_created_at
      # Note: I'm not too sure of the difference between the post_date and post_date_gmt.
      def convert_wordpress_post_date_gmt_to_created_at
        all_posts.each do |post|
          metadata = post.piece.metadata.raw_yaml

          unless metadata['wordpress'] && metadata['wordpress']['post_date_gmt']
            puts "skipping post: #{post.piece.name}"
            next
          end

          metadata['created_at'] = metadata['wordpress']['post_date_gmt']
          post.piece.metadata.raw_yaml = metadata
          post.piece.metadata.save_yaml
        end

        'done'
      end

      # Usage: From project directory, start irb and run with:
      #   require './lib/everything/blog/add_created_on';Everything::Blog::AddCreatedOn.new.convert_created_at_to_created_on
      def convert_created_at_to_created_on
        all_posts.each do |post|
          metadata = post.piece.metadata.raw_yaml

          unless metadata['created_at']
            puts "skipping post: #{post.piece.name}"
            next
          end

          created_at = Time.at(metadata['created_at'])
          if created_at <= latest_date_in_eastern_timezone
            # puts "Using Eastern Time for #{post.piece.title}"
            created_on = created_at.to_datetime.in_time_zone('Eastern Time (US & Canada)').to_date
          elsif created_at > latest_date_in_eastern_timezone && created_at <= latest_date_in_mountain_timezone
            # puts "Using Mountain Time for #{post.piece.title}"
            created_on = created_at.to_datetime.in_time_zone('Mountain Time (US & Canada)').to_date
          else
            # puts "Using Pacific Time for #{post.piece.title}"
            created_on = created_at.to_datetime.in_time_zone('Pacific Time (US & Canada)').to_date
          end

          metadata['created_on'] = created_on
          post.piece.metadata.raw_yaml = metadata
          post.piece.metadata.save_yaml
        end

        'done'
      end

      # Posts before this date are from when I lived in mountain time.
      def latest_date_in_eastern_timezone
        Time.new(2010,1,1,0,0,0,'-05:00')
      end

      # Posts before this date but after the prior date are from when I lived in mountain time.
      def latest_date_in_mountain_timezone
        Time.new(2017,1,1,0,0,0,'-07:00')
      end

    private

      def absolute_blog_path
        File.join(Everything.path, 'blog')
      end

      def all_post_dirs
        Dir.entries(absolute_blog_path) - files_to_ignore
      end

      def all_posts
        @all_posts ||= all_post_dirs.map { |post_name| Everything::Blog::Post.new(post_name) }
      end

      def files_to_ignore
        %w(. .. .DS_Store)
      end
    end
  end
end
