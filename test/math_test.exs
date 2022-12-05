defmodule MathTest do
  use ExUnit.Case
  import Math
  doctest Math

  test "cosine" do
    assert Math.cosine(0) <~> 1.0
    assert Math.cosine(0.5) <~> 0.8775825618903728
    assert Math.cosine(Math.pi) <~> -1.0
    assert Math.cosine(Math.pi/2) <~> 0.0
  end

  test "summation" do
    # Simple summation
    term_function = fn j -> j**2 end
    assert Math.summation(1, 100, term_function) == 338_350

    # Taylor expansion
    taylor_term = fn x, k -> power(-1, k) * power(x, 2*k) / factorial(2*k) end
    assert Math.summation(0, 16, 0, taylor_term) <~> 1.0
  end

  test "power" do
    assert Math.power(3, 2) == 9
  end

  test "factorial" do
    assert Math.factorial(3) == 6
  end
end
