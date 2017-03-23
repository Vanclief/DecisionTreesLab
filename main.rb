require 'active_support/core_ext/object/blank'

def read_input()
  input_lines = $stdin.readlines
  input_lines.reject!(&:blank?)
  input_lines
end

def parse_attributes(input_lines)
  attributes = Hash.new
  counter = 0

  input_lines.each do |line|


    attribute_name = line.match(/@attribute\s*(?<name>.*)\s*/)
    attribute_value = line.match(/\{(?<value>.*)\}/)

    if attribute_name
      attributes[attribute_name['name'].gsub(/\s.+/, '')] = [counter, attribute_value['value']]
      counter += 1
    end
  end
  attributes
end



# Read the input
input = read_input()
attributes = parse_attributes(input)
attributes.each do |key, index, value|
  puts "#{key}:#{index}:#{value}"
end


# Create the sections based from the input
# parsed = parse_input(input)
