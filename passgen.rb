def generate_code(length, complexity)
valid = 0 #check complexity
  until valid >= 4
    subsets = [("a".."z"), ("A".."Z"), (0..9), ("%".."*"), ("+".."?")]
    chars = subsets[0..complexity].map { |subset| subset.to_a }.flatten
    generated_code = chars.sample(length).join
    if !!(generated_code =~ (/[A-Z]/));
      valid += 1
      else
        valid += 0
    end
    if !!(generated_code =~ (/[a-z]/));
      valid += 1
      else
        valid += 0
    end
    if !!(generated_code =~ (/[0-9]/));
      valid += 1
      else
        valid += 0
    end
    if !!(generated_code =~ (/[%, (, ), *, +]/));
      valid += 1
      else
        valid += 0
    end
    if valid < 4 #reset valid if not equal to 4
      valid = 0
    end
  end
generated_code
end
