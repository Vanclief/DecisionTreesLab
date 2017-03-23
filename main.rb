require 'active_support/core_ext/object/blank'

def read_input()
  input_lines = $stdin.readlines
  input_lines.reject!(&:blank?)
  input_lines
end

def parse_input(input_lines)

  sections = {}
  current_section = nil

  input_lines.each do |line|
    # matching for attribute
    line.match(/@attribute\s*(?<value>.)\s*/)
    section = line.match(/\{(?<value>.*)\}/)
    parsed_line = line.downcase.gsub(/[\s^"]/ ,"")
    if section
      current_section = section['value']
      sections[current_section] = []
    else
      sections[current_section] << parsed_line
    end
  end
  sections
end

def parse_attributes(input_lines)
  attributes = Hash.new
  counter = 0

  input_lines.each do |line|

    attribute_name = line.match(/@attribute\s*(?<value>.)\s*/)
    attribute_values = line.match(/\{(?<value>.*)\}/)

    if attribute_name
      attributes[attribute_name] = [counter, attribute_values['value']]
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
