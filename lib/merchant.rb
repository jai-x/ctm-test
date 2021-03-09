# frozen_string_literal: true

Merchant = Struct.new(:key, :name, :domains, :literals) do
  def ==(other)
    key == other.key
  end

  def eql?(other)
    self == other
  end
end
