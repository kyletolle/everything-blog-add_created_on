# NOTE: This is a simplified version of the OO-ified Post class from everything-blog.
require 'forwardable'

module Everything
  class Blog
    class Post
      extend Forwardable

      def initialize(post_name)
        @post_name = post_name
      end

      def piece
        @piece ||= Everything::Piece.find_by_name_recursive(post_name)
      end

      def_delegators :piece, :name, :title, :body

    private

      attr_reader :post_name
    end
  end
end
