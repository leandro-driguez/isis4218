
defmodule BinarySearch do
  @doc """
  Searches for a key in the tuple using the binary search algorithm.
  It returns :not_found if the key is not in the tuple.
  Otherwise returns {:ok , index}.
  """
  @spec search(tuple, integer) :: {:ok , integer} | :not_found
  def search(items, key) do
    find(items, key, 0, tuple_size(items) - 1)
  end

  @spec find(tuple, integer, integer, integer) :: {:ok , integer} | :not_found
  defp find(_, _, l, r) when l > r, do: :not_found

  defp find(items, key, l, r) do
    m = l + div(r - l, 2)

    case elem(items, m) do
      ^key -> {:ok, m}
      value when value < key -> find(items, key, m + 1, r)
      value when value > key -> find(items, key, l, m - 1)
    end
  end
end
