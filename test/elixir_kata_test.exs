defmodule ElixirKataTest do
  use ExUnit.Case
  doctest ElixirKata

  @implementations [:my_reverse_1, :my_reverse_2, :my_reverse_3]

  test "string reverse" do
    for str <- ["", "abc", "aaaaaaaaaadfSQDF"], fun <- @implementations do
      assert String.reverse(str) == apply(ElixirKata, fun, [str])
    end
  end
end
