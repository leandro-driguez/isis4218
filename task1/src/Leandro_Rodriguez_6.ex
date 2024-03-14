
defmodule TopSecret do

  def to_ast(code) do
    {_, ast} = Code.string_to_quoted(code)
    ast
  end

  def decode_secret_message_part(ast_node, acc) do
    case ast_node do
      # recognize functions with guards
      {:def , _, [{:when, _, [{func_name, _, args} | _]} | _]} ->
        {ast_node, [get_func_name_prefix(func_name, length(args)) | acc]}
      {:defp, _, [{:when, _, [{func_name, _, args} | _]} | _]} ->
        {ast_node, [get_func_name_prefix(func_name, length(args)) | acc]}

      # recognize functions without guards
      {:def , _, [{func_name, _, args} | _]} ->
        {ast_node, [get_func_name_prefix(func_name, length(args)) | acc]}
      {:defp, _, [{func_name, _, args} | _]} ->
        {ast_node, [get_func_name_prefix(func_name, length(args)) | acc]}

      # if not a function definition
      _ -> {ast_node, acc}
    end
  end
  defp get_func_name_prefix(func_name_atom, n) do
    func_name_atom
    |> Atom.to_string()
    |> String.slice(0, n)
  end

  def decode_secret_message(code) do
    to_ast(code)
    |> visit()
    |> Enum.join()
  end

  defp visit({:def , _, _} = def_node) do
    decode_secret_message_part(def_node, [])
    |> elem(1)
  end
  defp visit({:defp, _, _} = defp_node) do
    decode_secret_message_part(defp_node, [])
    |> elem(1)
  end
  defp visit({_, _, args}) when is_list(args) do
    Enum.flat_map(args, &visit(&1))
  end
  defp visit([do: ast]), do: visit(ast)
  defp visit(_), do: []

end
