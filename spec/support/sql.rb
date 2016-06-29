def format_sql(string)
  string.strip.gsub(/\s+/, " ").gsub(/\(\s/, "(").gsub(/\s\)/, ")")
end
