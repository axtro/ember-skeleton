class EmberStripDebugFilter < Rake::Pipeline::Filter

  def strip_debug(data)
    # Strip debug code
    data.gsub!(%r{^(\s)+ember_(assert|deprecate|warn)\((.*)\).*$}, "")
  end


  def generate_output(inputs, output)
    inputs.each do |input|
      result = input.read
      strip_debug(result)
      output.write result
    end
  end
end
