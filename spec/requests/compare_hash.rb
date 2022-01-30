# compares that all the keys in the first hash have
# the same values in the second hash
def compare_hash(hash1, hash2)
  hash1.keys.all? { |key| hash1[key] == hash2[key] }
end