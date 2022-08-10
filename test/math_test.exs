defmodule MathTest do
  use ExUnit.Case
  doctest Math

  test "greets the world" do
    assert Math.hello() == :world
  end
end
