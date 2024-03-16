defmodule StmTest do
  use ExUnit.Case
  doctest Stm

  test "greets the world" do
    assert Stm.hello() == :world
  end
end
