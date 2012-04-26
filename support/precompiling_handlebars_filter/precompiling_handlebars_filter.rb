class PrecompilingHandlebarsFilter < Rake::Pipeline::Filter

  include Rake::Pipeline::Web::Filters::FilterWithDependencies

  # @return [Hash] a hash of options for generate_output
  attr_reader :options

  # @param [Hash] options
  #   options to pass to the output generator
  # @option options [String] :target
  #   the variable to store templates in
  # @param [Proc] block a block to use as the Filter's
  #   {#output_name_generator}.
  def initialize(options={},&block)
    # Convert .handlebars file extensions to .js
    block ||= proc { |input| input.sub(/\.handlebars$/, '.js') }
    super(&block)
    @options = {
        :target =>'Ember.TEMPLATES',
        :wrapper_proc => proc { |source| "Ember.Handlebars.compile(#{source});" },
        :precompiler_wrapper_proc => proc { |precompiled| "Ember.Handlebars.template(#{precompiled});"},
        :key_name_proc => proc { |input| File.basename(input.path, File.extname(input.path)) }
      }.merge(options)
  end

  def generate_output(inputs, output)

    inputs.each do |input|
      # The name of the template is the filename, sans extension
      name = options[:key_name_proc].call(input)

      if options[:precompile]
        source = input.read

        precompiled = js_context.call("precompileEmberHandlebars", source)

        output.write "#{options[:target]}['#{name}']=#{options[:precompiler_wrapper_proc].call(precompiled)}"
      else
        # Read the file and escape it so it's a valid JS string
        source = input.read.to_json

        # Write out a JS file, saved to target, wrapped in compiler
        output.write "#{options[:target]}['#{name}']=#{options[:wrapper_proc].call(source)}"
      end
    end
  end

  private

  def js_context
    # We're using Ember to precompile templates
    unless @context
      headless = File.read("support/precompiling_handlebars_filter/headless-ember.js")
      ember    = File.read("app/vendor/ember.js")
      @context = ExecJS.compile([headless, ember].join("\n"))
    end
    @context
  end

  def external_dependencies
    [ 'json', 'execjs' ]
  end
end
