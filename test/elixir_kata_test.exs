defmodule ElixirKataTest do
  use ExUnit.Case
  doctest ElixirKata

  @implementations ~w(my_reverse_1 my_reverse_2 my_reverse_3 my_reverse_4)a

  test "string reverse" do
    for str <- ["", "abc", "Hello World"], fun <- @implementations do
      assert String.reverse(str) == apply(ElixirKata, fun, [str])
    end
  end
end
