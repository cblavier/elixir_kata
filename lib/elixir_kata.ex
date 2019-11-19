defmodule ElixirKata do
  def my_reverse_1(str) do
    String.reverse(str)
  end

  defdelegate my_reverse_2(str), to: String, as: :reverse

  def my_reverse_3(str) do
    str |> String.to_charlist() |> my_reverse_3_recursive |> to_string()
  end

  defp my_reverse_3_recursive([]), do: []
  defp my_reverse_3_recursive([head | tail]), do: my_reverse_3_recursive(tail) ++ [head]

  def my_reverse_4(""), do: ""
  def my_reverse_4(<<head::size(8), tail::binary>>), do: my_reverse_4(tail) <> <<head>>
end
