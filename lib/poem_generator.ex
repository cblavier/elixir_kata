defmodule PoemGenerator do
  @doc ~S"""
  iex> PoemGenerator.sliding_window([0, 1, 2, 3, 4, 5], 3)
  [[0, 1, 2], [1, 2, 3], [2, 3, 4], [3, 4, 5] ]
  iex> PoemGenerator.sliding_window([0, 1, 2, 3, 4, 5], 1)
  [[0], [1], [2], [3], [4], [5]]
  iex> PoemGenerator.sliding_window([0, 1, 2, 3, 4, 5], 2)
  [[0, 1], [1, 2], [2, 3], [3, 4], [4, 5]]
  """
  def sliding_window(list, count) do
    Enum.chunk_every(list, count, 1, :discard)
  end

  @doc ~S"""
  iex> PoemGenerator.sliding_window_2([0, 1, 2, 3, 4, 5], 3)
  [[0, 1, 2], [1, 2, 3], [2, 3, 4], [3, 4, 5] ]
  iex> PoemGenerator.sliding_window_2([0, 1, 2, 3, 4, 5], 1)
  [[0], [1], [2], [3], [4], [5]]
  iex> PoemGenerator.sliding_window_2([0, 1, 2, 3, 4, 5], 2)
  [[0, 1], [1, 2], [2, 3], [3, 4], [4, 5]]
  """
  def sliding_window_2(list, count) do
    Enum.reduce(0..(Enum.count(list) - count), [], fn i, acc ->
      acc ++ [Enum.slice(list, i, count)]
    end)
  end
end
