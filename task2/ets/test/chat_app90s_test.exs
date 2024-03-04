defmodule ChatApp90sTest do
  use ExUnit.Case
  doctest ChatApp90s

  test "greets the world" do
    assert ChatApp90s.hello() == :world
  end
end
