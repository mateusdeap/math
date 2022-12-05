defmodule Math do
  @moduledoc """
  Documentation for `Math`.
  """

  # For practical uses floats can be considered equal if their difference is less than this value. See <~>.
  @epsilon 1.0e-15

  # Theoretical limit is 1.80e308, but Erlang errors at that value, so the practical limit is slightly below that one.
  @max_value 1.79_769_313_486_231_580_793e308

  # Default number of terms for any series expansion
  @number_of_terms 16

  @type x :: number
  @type y :: number

  @doc """
  The mathematical constant *π* (pi).
  The ratio of a circle's circumference to its diameter.
  The returned number is a floating-point approximation (as π is irrational)
  """
  @spec pi :: float
  defdelegate pi, to: :math

  @rad_in_deg 180 / :math.pi()

  @doc """
  The mathematical constant *ℯ* (e).
  """
  @spec e :: float
  def e, do: 2.718281828459045

  @doc """
  Equality-test for whether *x* and *y* are _nearly_ equal.
  This is useful when working with floating-point numbers, as these introduce small rounding errors.
  ## Examples
      iex> 2.3 - 0.3 == 2.0
      false
      iex> 2.3 - 0.3 <~> 2.0
      true
  """
  @spec number <~> number :: boolean
  def x <~> y do
    abs_x = abs(x)
    abs_y = abs(y)
    diff = abs(x - y)

    # Hacky comparison for floats that are nearly equal.
    cond do
      x == y ->
        true

      x == 0 or y == 0 ->
        diff < @epsilon

      true ->
        diff / min(abs_x + abs_y, @max_value) < @epsilon
    end
  end

  @doc """
  This function should return the cosine value of arg

  ## Examples

      iex> Math.cosine(0)
      1.0

  """
  def cosine(arg), do: cosine_taylor_expansion(arg, @number_of_terms)
  def cosine(arg, precision) do
    cosine_taylor_expansion(arg, @number_of_terms)
    |> Float.round(precision)
  end

  defp cosine_taylor_expansion(x, order) do
    summation(0, order, x, &taylor_cosine_term/2)
  end

  defp taylor_cosine_term(x, k) do
    power(-1, k) * power(x, 2*k) / factorial(2*k)
  end

  @doc """
  This function has 2 signatures.

  The first one is when we want to do a simple summation. It returns the sum
  of all terms given by `term_function` between `k0` and `k`.

  The second one is when we want to sum an expansion series which is usually
  done around a given point x0, it then returns the sum of all the terms
  between `k0` and `k` at the point `x0` where each term is a function of
  `x` and `k`, given by `term_function`.

  ## Examples
  
  """
  def summation(k0, k = k0, term_function), do: term_function.(k)
  def summation(k0, k, term_function) do
    term_function.(k) + summation(k0, k - 1, term_function)
  end
  def summation(k0, k = k0, x0, term_function), do: term_function.(x0, k)
  def summation(k0, k, x0, term_function) do
    term_function.(x0, k) + summation(k0, k - 1, x0, term_function)
  end

  @doc """
  Returns `x` to the power `pow`
  """
  def power(x, pow), do: x ** pow

  @doc """
  Calculates the factorial of a given number `n`
  """
  def factorial(n), do: factorial_of(n, 1)
  defp factorial_of(0, acc), do: acc
  defp factorial_of(n, acc) when n > 0, do: factorial_of(n - 1, n * acc)
end
