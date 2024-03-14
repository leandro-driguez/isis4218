
defmodule Triangle do
  @type kind :: :equilateral | :isosceles | :scalene

  @doc """
  Determines the type of a triangle given the lengths of its sides.
  """
  @spec kind(number, number, number) :: {:ok, kind} | {:error, String.t()}
  def kind(a, b, c) do
    cond do
      not is_triangle?(a, b, c) ->
        {:error, "Not a valid triangle"}
      a == b and b == c ->
        {:ok, :equilateral}
      a == b or a == c or b == c ->
        {:ok, :isosceles}
      true ->
        {:ok, :scalene}
    end
  end

  defp is_triangle?(a, b, c) do
    a + b > c and a + c > b and b + c > a and a > 0 and b > 0 and c > 0
  end
end
