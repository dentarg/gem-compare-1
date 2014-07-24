class Gem::Comparator
  class Report

    module Signs
      def same
        Rainbow('SAME').green.bright
      end

      def different
        Rainbow('DIFFERENT').red.bright
      end
    end

    def self.new(name = 'main')
      Gem::Comparator::Report::NestedSection.new(name)
    end

    class NestedSection
      include Report::Signs
      include Gem::UserInteraction

      DEFAULT_INDENT = '  '

      attr_reader :header, :messages, :parent_section, :level
      attr_accessor :name, :sections

      def initialize(name, parent_section = nil)
        @name = name
        @header = Entry.new
        @messages = []
        @sections = []
        @level = 0

        set_parent parent_section if parent_section
      end

      def section(&block)
        instance_eval &block
      end

      def set_header(message)
        @header = Entry.new(message)
      end

      def puts(message)
        @messages << Entry.new(message)
      end
      alias_method :<<, :puts

      def nest(name)
        @sections.each do |s|
          return s if s.name == name
        end
        NestedSection.new(name, self)
      end
      alias_method :[], :nest

      def print
        all_messages.each { |m| m.print }
      end

      def all_messages
        indent = DEFAULT_INDENT*@level

        if @header.empty?
          @messages.map do |m|
            m.set_indent!(indent)
          end + nested_messages
        else
          nested = @messages.map do |m|
            m.set_indent!(indent * 2)
          end + nested_messages
          return [] if nested.empty?

          @header.set_indent!(indent)
          nested.unshift(@header)
        end
      end

      def lines(line_num)
        all_messages[line_num].data
      end

      def nested_messages
        nested_messages = []
        @sections.each do |section|
          section.all_messages.each do |m|
            nested_messages << m
          end
        end
        nested_messages
      end

      private

        def set_parent(parent)
          parent.sections << self
          @level = parent.level + 1
          parent_section = parent
        end

    end

    class Entry
      include Gem::UserInteraction

      attr_accessor :data, :indent

      def initialize(data = '', indent = '')
        @data = data
        @indent = indent
      end

      def set_indent!(indent)
        @indent = indent
        self
      end

      def empty?
        case @data
        when String, Array
          @data.empty?
        end
      end

      def print
        printed = case @data
                  when String
                    "#{@indent}#{@data}"
                  when Array
                    @indent + @data.join("\n#{@indent}")
                  else
                    "#{@indent}#{@data}"
                  end
        say printed
      end
    end
  end
end
