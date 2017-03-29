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

    if data_flag and !line.start_with? '%'
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
  entropy = 0

  # Ok the following 3 lines make my eyes bleed, but Im in a hurry sorry
  attributes_array = attributes.to_a.last
  last_index = attributes_array[0]
  values = attributes[last_index][1].split(',')

  values.each do |value|
    value = value.strip
    c = 0

    data.each do |row|
      if row.last.include? value
        c += 1
      end
    end

    if c != 0
      e = c.to_f/data.length * Math.log2(c.to_f/data.length)
      entropy += e
    end
  end

  return entropy * -1

end

def get_information_gain(attribute, attributes, data, entropy)
  entropies = 0

  attribute_index = attributes[attribute][0]
  attribute_values = attributes[attribute][1].split(',')

  attribute_values.each do |attribute_value|
    filtered_data = Array.new
    attribute_value = attribute_value.strip

    data.each do |row|
      if row[attribute_index].include? attribute_value
        filtered_data.push(row)
      end
    end
    size =  filtered_data.length
    e =  get_entropy(attributes, filtered_data)
    entropies += e * size.to_f / data.length
  end

  return entropy - entropies

end

def get_max_info_gain(attributes, data)

  information_gains = Array.new
  max_index = 0

  entropy = get_entropy(attributes, data)
  keys = attributes.keys
  keys.pop #Remove the last key because those are the results

  keys.each do |key|

    # This method is also horroble... but it works. It gets the first max value from array
    if information_gains.length > 0

      max_information_gain = information_gains.max
      information_gain = get_information_gain(key, attributes, data, entropy)
      information_gains.push(information_gain)
      index = information_gains.index(information_gain)

      if  information_gain > max_information_gain
        max_index = index
      end

    else
      information_gain = get_information_gain(key, attributes, data, entropy)
      information_gains.push(information_gain)
    end
  end

  # puts entropy
  # puts information_gains.inspect
  return keys[max_index], information_gains.max

end

def isPure(attributes, set)

  last_index = set.first.length - 1
  attribute_value = set.first[last_index]

  set.each do |row|
    if row[last_index] != attribute_value
      return false
    end
  end

  return true

end

def split(attributes, data, depth)

  attribute, information_gain = get_max_info_gain(attributes, data)

  attribute_index = attributes[attribute][0]
  attribute_values = attributes[attribute][1].split(',')

  if isPure(attributes, data)
    print ''.ljust(depth)
    puts 'ANSWER: ' + data.first.last
  else
    attribute_values.each do |value|
      subset = Array.new
      value = value.strip
      print ''.ljust(depth)
      puts attribute + ': ' + value
      data.each do |row|
        if row[attribute_index].include? value
          subset.push(row)
        end
      end
      split(attributes, subset, depth + 2)
    end
  end

end

# Read the input
input = read_input()

# Parse the input
attributes = parse_attributes(input)
data = parse_data(input)

# Split database
split(attributes, data, 0)
