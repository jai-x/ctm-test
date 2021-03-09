# frozen_string_literal: true

Token = Struct.new(:type, :value) do
  def eql?(other)
    self == other
  end

  def ==(other)
    type == other.type && value == other.value
  end

  def to_s
    inspect
  end
end
