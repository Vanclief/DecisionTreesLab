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
      attributes[attribute_name['name']
      .gsub(/\s.+/, '')] = [counter, attribute_value['value']]
      counter += 1
    end
  end
  return attributes
end

def parse_data(input_lines)

  data = Array.new
  data_flag = false;

  input_lines.each do |line|

    data_line = line.match(/@data\s*(?<name>.*)\s*/)

    if data_flag
      line = line.strip
      line_arr = line.split(',')
      data.push(line_arr)
    end

    if data_line
      data_flag = true
    end
  end
  return data
end

def get_entropy(attributes, data)
  # Ok the following 3 lines make my eyes bleed, but Im in a hurry sorry
  attributes_array = attributes.to_a.last
  last_index = attributes_array[0]
  labels = attributes[last_index][1].split(',')
  labels.length


end

def info_gain()

end

# Read the input
input = read_input()

# Parse the input
attributes = parse_attributes(input)
data = parse_data(input)
entropy = get_entropy(attributes, data)

puts 'Attributes:'
puts attributes.inspect
puts 'Data:'
puts data.inspect
puts 'Entropy:'
puts entropy

#
