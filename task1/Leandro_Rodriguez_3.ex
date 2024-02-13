
defmodule WordCounter do
  @doc """
  Count the number of words in the sentence.
  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    lower_case = String.downcase(sentence)

    Regex.scan(~r/\b[a-zA-Z]+(?:'[a-zA-Z]+)?\b|\b\d+\b/, lower_case)
    |> Enum.map(&Enum.at(&1, 0))
    |> Enum.reduce(%{}, fn word, map ->
      Map.update(map, word, 1, &(&1 + 1))
    end)
  end
end
