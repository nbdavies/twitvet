def repeat_count(array)
  max = 0
  counts = Hash.new(0)
  array.each do |tweet|
    counts[tweet] += 1
    max = counts[tweet] if counts[tweet] > max
  end
  max - 1
end

def percentage(ratio)
  (ratio * 100).to_i
end

def log_scale(number)
  (number == 0 ? 0 : Math.log2(number))
end