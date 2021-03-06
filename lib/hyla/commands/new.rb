module Hyla
  module Commands
    class New < Command

      def self.process(args, options = {})
        raise ArgumentError.new('You must specify a destination.') if args.empty?

        @config = Hyla::Configuration.new

        #
        # Create Directory for the Project
        #
        new_project_path = File.expand_path(args.join(" "), Dir.pwd)

        if Dir.exist? new_project_path

          Hyla.logger.debug("Dir exists: #{new_project_path}")

          # If force is selected, then we delete & recreate it to clen content
          if options[:force]
            Hyla.logger.debug("Force option selected")
            # DOES NOT WORK ON Mac OS X
            # FileUtils.rmdir(new_project_path)
            FileUtils.rm_rf new_project_path
            # Create Directory
            FileUtils.mkdir_p new_project_path
            Hyla.logger.debug("Dir recreated it")
          end

          # Preserve content if it exists
          if preserve_content?(new_project_path)
            Hyla.logger.error "Conflict: ", "#{new_project_path} exists and is not empty."
            exit(1)
          end

        else
          # Create Directory
          FileUtils.mkdir_p new_project_path
        end

        #
        # Create blank project
        # or copy sample project from template directory
        #
        if options[:blank]
          create_blank_project new_project_path
        else
          raise ArgumentError.new('You must specifiy a template type.') if options[:template_type].nil?
          create_sample_project(new_project_path, options[:template_type])
        end

      end

      #
      # Create Blank Project
      # with just a readme.adoc file
      def self.create_blank_project(path)
        Dir.chdir(path) do
          f = File.open('sample.adoc', 'w')
          f.puts "= Sample Asciidoctor Project"
          f.puts "This is an empty AsciidocTor file."
          f.puts "To create **asciidoc(tor)** content, more info are available http://asciidoctor.org/docs/user-manual[here]"
        end
      end

      # Create a Sample Project
      # from a Template
      def self.create_sample_project(path, type)
        # TODO Test with ['',''] * '/'
        source = @config.templates + '/' + type + '/.'
        FileUtils.cp_r source, path
      end

      #
      # Preserve source location is folder is not empty
      def self.preserve_content?(path)
        !Dir["#{path}/**/*"].empty?
      end

    end # class
  end # module Commands
end # module Hyla