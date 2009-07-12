class Hash
  def join(sep = ',')
    pairs = []
    each_pair do |k, v|
      pairs << "#{k}: #{v}"
    end
    pairs.join(sep)
  end
end
