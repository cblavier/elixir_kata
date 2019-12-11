defmodule NGram do
  defstruct n: 2, model: []

  @doc ~S"""
  ## Examples
  iex> NGram.build_from_string("The blue sky is near the red koala near the blue sky", 2)
  %NGram{
    model: %{
      ["The", "blue"] => 1.0,
      ["blue", "sky"] => 1.0,
      ["is", "near"] => 1.0,
      ["koala", "near"] => 1.0,
      ["near", "the"] => 1.0,
      ["red", "koala"] => 1.0,
      ["sky", "is"] => 1.0,
      ["the", "blue"] => 0.5,
      ["the", "red"] => 0.5
    },
    n: 2
  }

  iex> NGram.build_from_string("The blue sky is near the red koala near the blue sky", 3)
  %NGram{
    model: %{
      ["The", "blue", "sky"] => 1.0,
      ["blue", "sky", "is"] => 1.0,
      ["is", "near", "the"] => 1.0,
      ["koala", "near", "the"] => 1.0,
      ["near", "the", "blue"] => 0.5,
      ["near", "the", "red"] => 0.5,
      ["red", "koala", "near"] => 1.0,
      ["sky", "is", "near"] => 1.0,
      ["the", "blue", "sky"] => 1.0,
      ["the", "red", "koala"] => 1.0
    },
    n: 3
  }
  """
  def build_from_string(string, n) do
    # Really basic tokenization on white spaces (not perfect but do the job)
    tokens = String.split(string, " ")

    model = tokens |> sliding_window(n) |> build_ngram_model()

    %NGram{n: n, model: model}
  end

  def build_ngram_model(chunks) do
    {prefix_occurences, chunk_occurences} =
      Enum.reduce(chunks, {%{}, %{}}, fn chunk, {prefix_acc, acc} ->
        chunk_prefix = Enum.slice(chunk, 0..-2)

        {
          Map.update(prefix_acc, chunk_prefix, 1, &(&1 + 1)),
          Map.update(acc, chunk, 1, &(&1 + 1))
        }
      end)

    Enum.reduce(chunks, %{}, fn chunk, acc ->
      chunk_prefix = Enum.slice(chunk, 0..-2)
      prefix_occurence = Map.get(prefix_occurences, chunk_prefix)
      chunk_occurence = Map.get(chunk_occurences, chunk)
      Map.put(acc, chunk, chunk_occurence / prefix_occurence)
    end)
  end

  def build_from_file(data_path, n) do
    model =
      data_path
      |> File.stream!()
      # Remove unwanted special characters
      |> Stream.map(fn line -> String.replace(line, "\n", "") end)
      # Remove empty lines
      |> Stream.reject(&(&1 == ""))
      |> Stream.map(&(String.split(&1, " ") |> sliding_window(n)))
      # |> Stream.take(50) # <--- Useful to avoid reading the whole files for test purposes
      |> Enum.flat_map(& &1)

    # |> # Add magic here

    %NGram{n: n, model: model}
  end

  @doc ~S"""
  ## Examples
      iex> NGram.sliding_window([1, 2, 3, 4, 5, 6, 7], 5)
      [[1, 2, 3, 4, 5], [2, 3, 4, 5, 6], [3, 4, 5, 6, 7]]

      iex> NGram.sliding_window([1, 2, 3, 4, 5, 6, 7], 2)
      [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7]]

      iex> NGram.sliding_window([1, 2, 3, 4, 5, 6, 7], 1)
      [[1], [2], [3], [4], [5], [6], [7]]
  """
  def sliding_window(list, count) do
    Enum.chunk_every(list, count, 1, :discard)
  end
end
