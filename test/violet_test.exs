defmodule VioletTest do
  use ExUnit.Case
  doctest Violet

  test "greets the world" do
    assert Violet.hello() == :world
  end
end
